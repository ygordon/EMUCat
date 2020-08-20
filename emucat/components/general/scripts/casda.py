import os
import sys
import xml.etree.ElementTree as ET
import pyvo as vo
import base64
import urllib.request
import argparse
import logging
import json

from retry import retry

URL = 'https://casda.csiro.au/casda_vo_tools/tap'

logging.basicConfig(stream=sys.stdout,
                    level=logging.INFO,
                    format='[%(asctime)s] {%(filename)s:%(lineno)d} %(levelname)s - %(message)s')


@retry(exceptions=urllib.error.URLError, tries=3, delay=1800, backoff=300)
def download_file(url, check_exists, output, timeout):
    # Large timeout is necessary as the file may need to be stage from tape
    logging.info(f"Requesting output: {output}")

    with urllib.request.urlopen(url, timeout=timeout) as r:
        http_size = int(r.info()['Content-Length'])
        if check_exists:
            try:
                file_size = os.path.getsize(output)
                if file_size == http_size:
                    logging.info(f"File exists, ignoring: {output}")
                    # File exists and is same size; do nothing
                    return
            except FileNotFoundError:
                pass

        logging.info(f"Downloading: {output} size: {http_size}")
        count = 0
        with open(output, 'wb') as o:
            while http_size > count:
                buff = r.read()
                if not buff:
                    break
                o.write(buff)
                count += len(buff)

        download_size = os.path.getsize(output)
        if http_size != download_size:
            raise ValueError(f"File size does not match file {download_size} and http {http_size}")

        logging.info(f"Download complete: {output}")


def download_casda_obscore_fits(rowset, check_exists, output_dir, timeout):
    weights = []
    images = []

    ns = {'ivoa': 'http://www.ivoa.net/xml/VOTable/v1.3'}
    for row in rowset:
        dl = row['access_url']
        filename = row['filename']
        dl = dl.decode("utf-8")
        filename = filename.decode("utf-8")
        req = urllib.request.Request(dl)

        username = os.environ['casda_user']
        password = os.environ['casda_pass']

        credentials = ('%s:%s' % (username, password))
        encoded_credentials = base64.b64encode(credentials.encode('ascii'))
        req.add_header('Authorization', 'Basic %s' % encoded_credentials.decode("ascii"))
        response = urllib.request.urlopen(req)
        data = response.read()
        xml = data.decode('utf-8')
        root = ET.fromstring(xml)

        first = root.findall('./ivoa:RESOURCE/ivoa:TABLE/ivoa:DATA/ivoa:TABLEDATA/ivoa:TR', ns)[0]
        output = f"{output_dir}/{filename}"
        download_file(first[1].text, check_exists, output, timeout)

        if 'image' in output:
            images.append(output)
        else:
            weights.append(output)

    return {'images': images, 'weights': weights}


def str2bool(v):
    if isinstance(v, bool):
       return v
    if v.lower() in ('yes', 'true', 't', 'y', '1'):
        return True
    elif v.lower() in ('no', 'false', 'f', 'n', '0'):
        return False
    else:
        raise argparse.ArgumentTypeError('Boolean value expected.')


def main():
    parser = argparse.ArgumentParser(description='Download images and weights from CASDA.')
    parser.add_argument('-l', '--list', nargs='+', help='List of observing block numbers.', type=int, required=True)
    parser.add_argument('-o', '--output', help='Output directory.', type=str, required=True)
    parser.add_argument('-m', '--manifest', help='File manifest (json)', type=str, required=True, default='./manifest.json')
    parser.add_argument('-c', '--check_exists', type=str2bool, nargs='?',
                        const=True, help='Ignore files if they already exist.', required=False, default=False)
    parser.add_argument('-n', '--num_files', help='Number of files expected per observation block.',
                        type=int, required=False, default=4)
    parser.add_argument('-t', '--timeout', help='URL timeout (s).',
                        type=int, required=False, default=3000)

    args = parser.parse_args()
    if len(args.list) == 0:
        raise ValueError('Observing block numbers empty.')

    if not args.output:
        raise ValueError('Output directory not defined.')

    try:
        os.makedirs(args.output)
    except:
        pass

    try:
        os.makedirs(os.path.abspath(os.path.dirname(args.manifest)))
    except:
        pass

    obs_list = ', '.join(f"'{str(i)}'" for i in args.list)

    # Example: '9287', '9325', '9351', '9410', '9434', '9437', '9442', '9501', '10083', '10635'
    query = f"select * from ivoa.obscore where obs_id in ({obs_list}) and " \
            f"(filename like 'weights.i.%.cont.taylor._.fits' or filename like 'image.i.%.cont.taylor._.restored.fits')"

    service = vo.dal.TAPService(URL)
    rowset = service.search(query)

    if len(args.list) * args.num_files != len(rowset):
        raise ValueError(f"Number of files expected {len(args.list) * args.num_files} "
                         f"does not match query result {len(rowset)}")

    result = download_casda_obscore_fits(rowset,
                                            check_exists=args.check_exists,
                                            output_dir=args.output,
                                            timeout=args.timeout)

    with open(args.manifest, 'w') as json_file:
        json.dump(result, json_file)


if __name__ == "__main__":
    try:
        main()
        exit(0)
    except Exception as e:
        logging.exception(e)
        exit(1)

