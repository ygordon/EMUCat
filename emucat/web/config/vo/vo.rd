<resource schema="emucat">
   <meta name="title">EMUCat</meta>
    <meta name="description">EMUCat</meta>
    <meta name="copyright" format="plain">EMUCat</meta>
    <meta name="creationDate">2020-04-30T12:00:00Z</meta>

   <table id="source_extraction_regions" onDisk="True" adql="True">
      <column name="id" type="bigint" unit="" ucd="meta.id;meta.main"/>
      <column name="name" type="text" unit="" ucd="meta.id"/>
      <column name="extent" ucd="" type="spoly" unit=""/>
      <column name="centre" ucd="pos.eq.ra;pos.eq.dec" type="spoint" unit=""/>
   </table>

   <table id="scheduling_blocks" onDisk="True" adql="True">
      <column name="id" type="bigint" unit="" ucd="meta.id;meta.main"/>
      <column name="sb_num" type="bigint" unit="" ucd="meta.id"/>
   </table>

   <table id="mosaic_prerequisites" onDisk="True" adql="True">
      <column name="id" type="bigint" unit="" ucd="meta.id;meta.main"/>
      <column name="sb_num" type="bigint" unit="" ucd="meta.id"/>
      <column name="ser_id" type="bigint" unit="" ucd="meta.id"/>

      <foreignKey source="sb_num" dest="id" inTable="scheduling_blocks"/>
      <foreignKey source="ser_id" dest="id" inTable="source_extraction_regions"/>
   </table>

   <table id="mosaics" onDisk="True" adql="True">
      <column name="id" type="bigint" unit="" ucd="meta.id;meta.main"/>
      <column name="ser_id" type="bigint" unit="" ucd="meta.id"/>
      <column name="table_version" ucd="meta.version" type="text"/>
      <column name="image_file" ucd="meta.file;meta.fits" type="text"/>
      <column name="flag_subsection" ucd="meta.code"/>
      <column name="subsection" ucd="" type="text"/>
      <column name="flag_statsec" ucd="meta.code"/>
      <column name="statsec" ucd="" type="text"/>
      <column name="search_type" ucd="meta.note" type="text"/>
      <column name="flag_negative" ucd="meta.code" type="boolean"/>
      <column name="flag_baseline" ucd="meta.code" type="boolean"/>
      <column name="flag_robuststats" ucd="meta.code" type="boolean"/>
      <column name="flag_fdr" ucd="meta.code" type="boolean"/>
      <column name="threshold" ucd="phot.flux;stat.min" type="double precision"/>
      <column name="flag_growth" ucd="meta.code" type="boolean"/>
      <column name="growth_threshold" ucd="phot.flux;stat.min" type="double precision"/>
      <column name="min_pix" ucd="" type="integer"/>
      <column name="min_channels" ucd="" type="integer"/>
      <column name="min_voxels" ucd="" type="integer"/>
      <column name="flag_adjacent" ucd="meta.code" type="boolean"/>
      <column name="thresh_velocity" ucd="" type="double precision"/>
      <column name="flag_rejectbeforemerge" ucd="" type="boolean"/>
      <column name="flag_twostagemerging" ucd="" type="boolean"/>
      <column name="pixel_centre" ucd="" type="text"/>
      <column name="flag_smooth" ucd="meta.code" type="boolean"/>
      <column name="flag_atrous" ucd="meta.code" type="boolean"/>
      <column name="reference_frequency" ucd="em.freq;meta.main" type="double precision" unit="Hz"/>
      <column name="threshold_actual" ucd="" type="double precision" unit="Jy/beam"/>

      <foreignKey source="ser_id" dest="id" inTable="source_extraction_regions"/>
   </table>

   <table id="components" onDisk="True" adql="True">
      <index columns="id"/>
      <column name="id" type="bigint" unit="" ucd="meta.id;meta.main"/>
      <column name="mosaic_id" type="bigint" unit="" ucd="meta.id"/>
      <column name="island_id" ucd="meta.id.parent" type="text"/>
      <column name="component_id" ucd="meta.id;meta.main" type="text"/>
      <column name="component_name" ucd="meta.id" type="text" unit=""/>
      <column name="ra_hms_cont" ucd="pos.eq.ra" type="text" unit=""/>
      <column name="dec_hms_cont" ucd="pos.eq.dec" type="text" unit=""/>
      <column name="ra_deg_cont" ucd="pos.eq.ra;meta.main" type="double precision" unit="deg"/>
      <column name="dec_deg_cont" ucd="pos.eq.dec;meta.main" type="double precision" unit="deg"/>
      <column name="ra_err" ucd="stat.error;pos.eq.ra" type="double precision" unit="arcsec" />
      <column name="dec_err" ucd="stat.error;pos.eq.dec" type="double precision" unit="arcsec"/>
      <column name="freq" ucd="em.freq" type="double precision" unit="MHz"/>
      <column name="flux_peak" ucd="phot.flux.density;stat.max;em.radio;stat.fit" type="double precision" unit="mJy/beam"/>
      <column name="flux_peak_err" ucd="stat.error;phot.flux.density;stat.max;em.radio;stat.fit" type="double precision" unit="mJy/beam"/>
      <column name="flux_int" ucd="phot.flux.density;em.radio;stat.fit" type="double precision" unit="mJy"/>
      <column name="flux_int_err" ucd="stat.error;phot.flux.density;em.radio;stat.fit" type="double precision" unit="mJy"/>
      <column name="maj_axis" ucd="phys.angSize.smajAxis;em.radio;stat.fit" type="double precision" unit="arcsec"/>
      <column name="min_axis" ucd="phys.angSize.sminAxis;em.radio;stat.fit" type="double precision" unit="arcsec"/>
      <column name="pos_ang" ucd="phys.angSize;pos.posAng;em.radio;stat.fit" type="double precision" unit="deg"/>
      <column name="maj_axis_err" ucd="stat.error;phys.angSize.smajAxis;em.radio" type="double precision" unit="arcsec"/>
      <column name="min_axis_err" ucd="stat.error;phys.angSize.sminAxis;em.radio" type="double precision" unit="arcsec"/>
      <column name="pos_ang_err" ucd="stat.error;phys.angSize;pos.posAng;em.radio" type="double precision" unit="deg"/>
      <column name="maj_axis_deconv" ucd="phys.angSize.smajAxis;em.radio;askap:meta.deconvolved" type="double precision" unit="arcsec"/>
      <column name="min_axis_deconv" ucd="phys.angSize.sminAxis;em.radio;askap:meta.deconvolved" type="double precision" unit="arcsec"/>
      <column name="pos_ang_deconv" ucd="phys.angSize;pos.posAng;em.radio;askap:meta.deconvolved" type="double precision" unit="deg"/>
      <column name="maj_axis_deconv_err" ucd="stat.error;phys.angSize.smajAxis;em.radio;askap:meta.deconvolved" type="double precision" unit="arcsec"/>
      <column name="min_axis_deconv_err" ucd="stat.error;phys.angSize.sminAxis;em.radio;askap:meta.deconvolved" type="double precision" unit="arcsec"/>
      <column name="pos_ang_deconv_err" ucd="stat.error;phys.angSize;pos.posAng;em.radio;askap:meta.deconvolved" type="double precision" unit="deg"/>
      <column name="chi_squared_fit" ucd="stat.fit.chi2" type="double precision" />
      <column name="rms_fit_gauss" ucd="stat.stdev;stat.fit" type="double precision" unit="mJy/beam" />
      <column name="spectral_index" ucd="spect.index;em.radio" type="double precision"/>
      <column name="spectral_curvature" ucd="askap:spect.curvature;em.radio" type="double precision"/>
      <column name="spectral_index_err" ucd="stat.error;spect.index;em.radio" type="double precision"/>
      <column name="spectral_curvature_err" ucd="stat.error;askap:spect.curvature;em.radio" type="double precision"/>
      <column name="rms_image" ucd="stat.stdev;phot.flux.density" type="double precision" unit="mJy/beam"/>
      <column name="has_siblings" ucd="meta.code" type="integer"/>
      <column name="fit_is_estimate" ucd="meta.code" type="integer"/>
      <column name="spectral_index_from_tt" ucd="meta.code"/>
      <column name="flag_c4" ucd="meta.code" type="integer"/>
      <column name="comment" ucd="meta.note" type="text"/>

      <foreignKey source="mosaic_id" dest="id" inTable="mosaics"/>
   </table>

    <table id="allwise" onDisk="True" adql="True">
      <column name="designation" type="text" unit="" ucd="meta.id;meta.main"/>
      <column name="ra_dec" type="spoint" unit="" ucd="pos.eq.ra;pos.eq.dec"/>
   </table>

   <table id="sources" onDisk="True" adql="True">
      <column name="id" type="bigint" unit="" ucd="meta.id;meta.main"/>
      <column name="component_id" type="bigint" unit="" ucd="meta.id"/>
      <column name="wise_id" type="bigint" unit="" ucd="meta.id"/>
      <column name="separation" type="double precision" unit="rad" ucd="meta.id"/>

      <foreignKey source="component_id" dest="id" inTable="components"/>
      <foreignKey source="wise_id" dest="id" inTable="allwise"/>
   </table>

   <data id="import">
      <make table="source_extraction_regions"/>
      <make table="scheduling_blocks"/>
      <make table="mosaic_prerequisites"/>
      <make table="mosaics"/>
      <make table="components"/>
      <make table="sources"/>
      <make table="allwise"/>
   </data>
</resource>