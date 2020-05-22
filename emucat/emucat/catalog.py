import xml.etree.ElementTree as ET
import aiofiles
import asyncio
import asyncpg
import csv
import random
import string


async def db_moasic_upsert(conn, row):
    mosaic_id = await conn.fetchrow('INSERT INTO emucat.mosaics ("ser_id", "table_version", "image_file", '
                                     '"flag_subsection",'
                                     '"subsection", "flag_statsec", "statsec", "search_type", "flag_negative", '
                                     '"flag_baseline", "flag_robuststats", "flag_fdr", "threshold", "flag_growth", '
                                     '"growth_threshold", "min_pix", "min_channels", "min_voxels", "flag_adjacent", '
                                     '"thresh_velocity", "flag_rejectbeforemerge", "flag_twostagemerging", '
                                     '"pixel_centre", "flag_smooth", "flag_atrous", "reference_frequency", '
                                     '"threshold_actual") '
                                     'VALUES($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15,'
                                     '$16, $17, $18, $19, $20, $21, $22, $23, $24, $25, $26, $27) '
                                     'ON CONFLICT ("ser_id", "subsection") '
                                     'DO UPDATE SET subsection = EXCLUDED.subsection RETURNING id',
                                     *row)
    return mosaic_id[0]


async def db_components_upsert_many(conn, rows):
    await conn.executemany('INSERT INTO emucat.components ("mosaic_id","island_id","component_id",'
                                     '"component_name","ra_hms_cont","dec_hms_cont","ra_deg_cont",'
                                     '"dec_deg_cont","ra_err","dec_err","freq","flux_peak","flux_peak_err",'
                                     '"flux_int","flux_int_err","maj_axis","min_axis","pos_ang","maj_axis_err",'
                                     '"min_axis_err","pos_ang_err","maj_axis_deconv","min_axis_deconv",'
                                     '"pos_ang_deconv","maj_axis_deconv_err","min_axis_deconv_err",'
                                     '"pos_ang_deconv_err","chi_squared_fit","rms_fit_gauss","spectral_index",'
                                     '"spectral_curvature","spectral_index_err","spectral_curvature_err",'
                                     '"rms_image","has_siblings","fit_is_estimate","spectral_index_from_tt",'
                                     '"flag_c4","comment")'
                                     'VALUES($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15,'
                                     '$16, $17, $18, $19, $20, $21, $22, $23, $24, $25, $26, $27, $28, $29,'
                                     '$30, $31, $32, $33, $34, $35, $36, $37, $38, $39) '
                                     'ON CONFLICT ("mosaic_id", "component_name", "ra_deg_cont", "dec_deg_cont") DO NOTHING',
                                     rows)


async def _get_file_bytes(path: str, mode: str = 'rb'):
    buffer = []

    async with aiofiles.open(path, mode) as f:
        while True:
            buff = await f.read()
            if not buff:
                break
            buffer.append(buff)
        if 'b' in mode:
            return b''.join(buffer)
        else:
            return ''.join(buffer)


def convert(value, datatype):
    if datatype == 'float':
        return float(value)
    elif datatype =='boolean':
        return bool(value)
    elif datatype == 'int':
        return int(value)
    elif datatype == 'double':
        return float(value)
    return value


async def import_selavy_catalog(conn, ser_name: str, filename: str):
    ser_id = await conn.fetchrow('SELECT id from emucat.source_extraction_regions where name=$1', ser_name)
    if not ser_id:
        raise Exception('Source extraction region not found')

    ser_id = ser_id[0]

    ns = {'ivoa': 'http://www.ivoa.net/xml/VOTable/v1.3'}

    content = await _get_file_bytes(filename, mode='r')
    root = ET.fromstring(content)

    params = []
    for param in root.findall('./ivoa:RESOURCE/ivoa:TABLE/ivoa:PARAM', ns):
        params.append(convert(param.get('value'), param.get('datatype')))

    params.insert(0, ser_id)

    mosaic_id = await db_moasic_upsert(conn, params)

    datatypes = []
    for field in root.findall('./ivoa:RESOURCE/ivoa:TABLE/ivoa:FIELD', ns):
        datatypes.append(field.get('datatype'))

    rows = []
    for i, tr in enumerate(root.findall('./ivoa:RESOURCE/ivoa:TABLE/ivoa:DATA/ivoa:TABLEDATA/ivoa:TR', ns)):
        cat = [convert(td.text.strip(), datatypes[j]) for j, td in enumerate(tr)]
        cat.insert(0, mosaic_id)
        rows.append(cat)

    await db_components_upsert_many(conn, rows)


async def import_selavy_votable(ser_name: str, filename: str):
    conn = await asyncpg.connect(user='admin', password='admin', database='emucat', host='localhost')
    await import_selavy_catalog(conn, ser_name, filename)


def parse_allwise_votable(filename: str):
    ns = 'http://www.ivoa.net/xml/VOTable/v1.3'
    ET.register_namespace("ivoa", ns)
    q = ET.QName(ns, "TR")
    context = ET.iterparse(filename, events=("start", "end"))
    context = iter(context)
    ev, root = next(context)

    for ev, el in context:
        if ev == 'end' and el.tag == q:
            data = [el[0].text, f'({el[1].text}d, {el[2].text}d)']
            yield data
            root.clear()


async def export_allwise_votable_to_csv(input_path: str, output_path: str):
    with open(output_path, 'w', newline='') as f:
        writer = csv.writer(f)
        for data in parse_wise_votable(input_path):
            writer.writerows([data])


def random_word(length):
   letters = string.ascii_lowercase
   return ''.join(random.choice(letters) for i in range(length))


async def import_allwise_catalog_from_csv(input_path: str):
    conn = await asyncpg.connect(user='admin', password='admin', database='emucat', host='localhost')
    async with conn.transaction():
        with open(input_path, 'rb') as f:
            table_name = random_word(6)
            temp_sql = f'CREATE TEMP TABLE {table_name} ON COMMIT DROP AS SELECT * FROM emucat.allwise WITH NO DATA;'
            await conn.fetchrow(temp_sql)
            copy_result = await conn.copy_to_table(table_name=table_name, source=f, format='csv')
            print(copy_result)
            copy_sql = f'INSERT INTO emucat.allwise SELECT * FROM {table_name} ORDER BY (designation) ' \
                       f'ON CONFLICT (designation) DO NOTHING'
            await conn.fetchrow(copy_sql)

