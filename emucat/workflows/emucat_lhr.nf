params.ser = 'EMU_2137-5300'
params.emu_vo_url = 'http://146.118.67.65:8080/tap'

params.INPUT_CONF = "${params.SCRATCH_ROOT}/data/emu/emucat"
params.OUTPUT_RAW = "${params.SCRATCH_ROOT}/data/emu/data/raw"
params.OUTPUT_LINMOS = "${params.SCRATCH_ROOT}/data/emu/data/linmos"
params.OUTPUT_SELAVY = "${params.SCRATCH_ROOT}/data/emu/data/selavy"
params.OUTPUT_LOG_DIR = "${params.SCRATCH_ROOT}/data/emu/log"

process get_sched_blocks {

    errorStrategy 'retry'
    maxErrors 3

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

    errorStrategy 'retry'
    maxErrors 3

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
    image_out = Path('${params.OUTPUT_LINMOS}/${params.ser}.image.taylor.0')
    weight_out = Path('${params.OUTPUT_LINMOS}/${params.ser}.weights.taylor.0')

    j2_env = Environment(loader=FileSystemLoader('${params.INPUT_CONF}/templates'), trim_blocks=True)
    result = j2_env.get_template('linmos.j2').render(images=images, weights=weights, \
    image_out=image_out, weight_out=weight_out)

    with open('linmos.conf', 'w') as f:
        print(result, file=f)
    """
}


process run_linmos {

    input:
    file(linmos) from linmos_conf

    output:
    val "${params.OUTPUT_LINMOS}/${params.ser}.image.taylor.0.fits" into image_out
    val "${params.OUTPUT_LINMOS}/${params.ser}.weights.taylor.0.fits" into weight_out

    """
    #!/bin/bash
    cat $linmos
    """
}


process generate_selavy_conf {

    input:
    path image_input from image_out
    path weight_input from weight_out

    output:
    file 'selavy.conf' into selavy_conf
    file 'yandasoft.log_cfg' into selavy_log_conf

    """
    #! singularity exec --bind ${params.SCRATCH_ROOT}:${params.SCRATCH_ROOT} ${params.IMAGES}/general.sif python3
    from jinja2 import Environment, FileSystemLoader
    from pathlib import Path

    image = Path('${image_input.toRealPath()}')
    weight = Path('${weight_input.toRealPath()}')
    log = Path('${params.OUTPUT_LOG_DIR}/${params.ser}_selavy.log')
    results = Path('${params.OUTPUT_SELAVY}/${params.ser}_results.txt')
    votable = Path('${params.OUTPUT_SELAVY}/${params.ser}_votable.xml')
    annotations = Path('${params.OUTPUT_SELAVY}/${params.ser}_annotations.ann')

    j2_env = Environment(loader=FileSystemLoader('${params.INPUT_CONF}/templates'), trim_blocks=True)
    result = j2_env.get_template('selavy.j2').render(image=image, weight=weight, \
             results=results, votable=votable, annotations=annotations)

    with open('selavy.conf', 'w') as f:
        print(result, file=f)

    result = j2_env.get_template('yandasoft_log.j2').render(log=log)

    with open('yandasoft.log_cfg', 'w') as f:
        print(result, file=f)
    """
}

process run_selavy {

    executor = 'slurm'
    clusterOptions = '--nodes=20 --ntasks-per-node=6'

    input:
    file(selavy_conf) from selavy_conf
    file(selavy_log_conf) from selavy_log_conf

    output:


    """
    #!/bin/bash
    mpirun singularity exec --bind ${params.SCRATCH_ROOT}:${params.SCRATCH_ROOT} \
    ${params.IMAGES}/yandasoft.sif selavy -c ${selavy_conf.toRealPath()} -l ${selavy_log_conf.toRealPath()}
    """
}