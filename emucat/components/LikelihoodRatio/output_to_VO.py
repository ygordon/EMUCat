###needs to take Morabito LR code output and convert to VOTable for EMUcat

import argparse
from astropy.table import Table

def output_to_VOTable(filename, over_write=True):
    data = Table.read(filename, format='ascii')
    data.write(filename + '.xml', format='votable')
    return


####parse command line args
parser = argparse.ArgumentParser()
parser.add_argument('LR_out', type=str,
                    help='LR output file to convert to VOTable for EMUcat')

args = parser.parse_args()

output_to_VOTable(filename=args.LR_out)
