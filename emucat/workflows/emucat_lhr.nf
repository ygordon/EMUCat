params.ser = 'EMU_2137-5300'
params.emu_vo_url = 'http://146.118.67.65:8080/tap'

params.INPUT_CONF = "${params.SCRATCH_ROOT}/data/emu/emucat"
params.OUTPUT_RAW = "${params.SCRATCH_ROOT}/data/emu/data/raw"
params.OUTPUT_LINMOS = "${params.SCRATCH_ROOT}/data/emu/data/linmos"


process get_sched_blocks {

    input:
    val params.ser

    output:
    stdout into obs_out

    """
    #! singularity exec --bind ${params.SCRATCH_ROOT}:${params.SCRATCH_ROOT} ${params.IMAGES}/general.sif python3
    import pyvo as vo

    query = f"SELECT sb.sb_num " \
            f"FROM emucat.source_extraction_regions as ser, " \
            f"emucat.mosaic_prerequisites as mp, " \
            f"emucat.scheduling_blocks as sb " \
            f"WHERE ser.id = mp.ser_id and mp.sb_id = sb.id and ser.name = '${params.ser}'"

    service = vo.dal.TAPService('${params.emu_vo_url}')
    rowset = service.search(query)
    for r in rowset:
        print(r['sb_num'], end=" ")
    """
}


process casda_download {

    input:
    stdin from obs_out

    output:
    file 'manifest.json' into file_manifest

    """
    singularity exec \
    --bind ${params.SCRATCH_ROOT}:${params.SCRATCH_ROOT} \
    ${params.IMAGES}/general.sif \
    python3 /scripts/casda.py --list $obs_out.value -o ${params.OUTPUT_RAW} -m manifest.json -p ${params.INPUT_CONF}/cred.ini -c true
    """
}


process generate_linmos_conf {

    input:
    file(manifest) from file_manifest

    output:
    file 'linmos.conf' into linmos_conf

    """
    #! singularity exec --bind ${params.SCRATCH_ROOT}:${params.SCRATCH_ROOT} ${params.IMAGES}/general.sif python3
    import json
    from jinja2 import Environment, FileSystemLoader
    from pathlib import Path

    with open('${manifest.toRealPath()}') as o:
       data = json.loads(o.read())

    images = [Path(image).with_suffix('') for image in data['images'] if '.0.' in image]
    weights = [Path(weight).with_suffix('') for weight in data['weights'] if '.0.' in weight]
    image_out = Path('${params.OUTPUT_RAW}/${params.ser}.image.0')
    weight_out = Path('${params.OUTPUT_RAW}/${params.ser}.weights.0')

    j2_env = Environment(loader=FileSystemLoader('${params.INPUT_CONF}/templates'), trim_blocks=True)
    result = j2_env.get_template('linmos.j2').render(images=images, weights=weights, \
    image_out=image_out, weight_out=weight_out)

    with open('linmos.conf', 'w') as f:
        print(result, file=f)
    """
}


process print_linmos_conf {

    input:
    file(linmos) from linmos_conf

    output:
    stdout result

    script:
    """
    cat $linmos
    """
}

result.subscribe { println it }