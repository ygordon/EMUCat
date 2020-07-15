<resource schema="emucat">
   <meta name="title">EMUCat</meta>
    <meta name="description">EMUCat</meta>
    <meta name="copyright" format="plain">EMUCat</meta>
    <meta name="creationDate">2020-04-30T12:00:00Z</meta>

   <table id="source_extraction_regions" onDisk="True" adql="True">
      <column name="id" type="bigint" unit="" ucd="meta.id;meta.main"/>
      <column name="name" type="text" unit="" ucd="meta.id"/>
      <column name="extent" ucd="" type="sbox" unit=""/>
      <column name="centre" ucd="pos.eq.ra;pos.eq.dec" type="spoint" unit=""/>
   </table>

   <table id="scheduling_blocks" onDisk="True" adql="True">
      <column name="id" type="bigint" unit="" ucd="meta.id;meta.main"/>
      <column name="sb_num" type="bigint" unit="" ucd="meta.id"/>
   </table>

   <table id="mosaic_prerequisites" onDisk="True" adql="True">
      <column name="id" type="bigint" unit="" ucd="meta.id;meta.main"/>
      <column name="sb_id" type="bigint" unit="" ucd="meta.id"/>
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
       <column name="ra_dec" type="spoint" unit="" ucd="pos.eq.ra;pos.eq.dec"/>
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
       <column name="ra" type="double precision" unit="deg" ucd="pos.eq.ra;meta.main" description="right ascension (J2000)" />
       <column name="dec" type="double precision" unit="deg" ucd="pos.eq.dec;meta.main" description="declination (J2000)" />
      <column name="sigra" type="double precision" unit="arcsec" ucd="" description="uncertainty in RA" />
      <column name="sigdec" type="double precision" unit="arcsec" ucd="" description="uncertainty in DEC" />
      <column name="sigradec" type="double precision" unit="arcsec" ucd="" description="cross-term of RA and Dec uncertainties" />
      <column name="glon" type="double precision" unit="deg" ucd="" description="galactic longitude" />
      <column name="glat" type="double precision" unit="deg" ucd="" description="galactic latitude" />
      <column name="elon" type="double precision" unit="deg" ucd="" description="ecliptic longitude" />
      <column name="elat" type="double precision" unit="deg" ucd="" description="ecliptic latitude" />
      <column name="wx" type="double precision" unit="pix" ucd="" description="x-pixel coordinate, all bands" />
      <column name="wy" type="double precision" unit="pix" ucd="" description="y-pixel coordinate, all bands" />
      <column name="cntr" type="bigint" unit="" ucd="meta.record;meta.main" description="unique entry counter (key) number" />
      <column name="source_id" type="text" unit="" ucd="" description="unique source ID (coadd ID and source number)" />
      <column name="coadd_id" type="text" unit="" ucd="" description="coadd ID" />
      <column name="src" type="integer" unit="" ucd="" description="source number in coadd" />
      <column name="w1mpro" type="double precision" unit="mag" ucd="" description="instrumental profile-fit photometry magnitude, band 1" />
      <column name="w1sigmpro" type="double precision" unit="mag" ucd="" description="instrumental profile-fit photometry flux uncertainty in mag units, band 1" />
      <column name="w1snr" type="double precision" unit="" ucd="" description="instrumental profile-fit photometry S/N ratio, band 1" />
      <column name="w1rchi2" type="double precision" unit="" ucd="" description="instrumental profile-fit photometry reduced chi^2, band 1" />
      <column name="w2mpro" type="double precision" unit="mag" ucd="" description="instrumental profile-fit photometry magnitude, band 2" />
      <column name="w2sigmpro" type="double precision" unit="mag" ucd="" description="instrumental profile-fit photometry flux uncertainty in mag units, band 2" />
      <column name="w2snr" type="double precision" unit="" ucd="" description="instrumental profile-fit photometry S/N ratio, band 2" />
      <column name="w2rchi2" type="double precision" unit="" ucd="" description="instrumental profile-fit photometry reduced chi^2, band 2" />
      <column name="w3mpro" type="double precision" unit="mag" ucd="" description="instrumental profile-fit photometry magnitude, band 3" />
      <column name="w3sigmpro" type="double precision" unit="mag" ucd="" description="instrumental profile-fit photometry flux uncertainty in mag units, band 3" />
      <column name="w3snr" type="double precision" unit="" ucd="" description="instrumental profile-fit photometry S/N ratio, band 3" />
      <column name="w3rchi2" type="double precision" unit="" ucd="" description="instrumental profile-fit photometry reduced chi^2, band 3" />
      <column name="w4mpro" type="double precision" unit="mag" ucd="" description="instrumental profile-fit photometry magnitude, band 4" />
      <column name="w4sigmpro" type="double precision" unit="mag" ucd="" description="instrumental profile-fit photometry flux uncertainty in mag units, band 4" />
      <column name="w4snr" type="double precision" unit="" ucd="" description="instrumental profile-fit photometry S/N ratio, band 4" />
      <column name="w4rchi2" type="double precision" unit="" ucd="" description="instrumental profile-fit photometry reduced chi^2, band 4" />
      <column name="rchi2" type="double precision" unit="" ucd="" description="instrumental profile-fit photometry reduced chi squared, total" />
      <column name="nb" type="integer" unit="" ucd="" description="number of blend components used in each fit" />
      <column name="na" type="integer" unit="" ucd="" description="active deblend flag (=1 if actively deblended)" />
      <column name="w1sat" type="double precision" unit="" ucd="" description="fraction of pixels affected by saturation, band 1" />
      <column name="w2sat" type="double precision" unit="" ucd="" description="fraction of pixels affected by saturation, band 2" />
      <column name="w3sat" type="double precision" unit="" ucd="" description="fraction of pixels affected by saturation, band 3" />
      <column name="w4sat" type="double precision" unit="" ucd="" description="fraction of pixels affected by saturation, band 4" />
      <column name="satnum" type="text" unit="" ucd="" description="minimum sample at which saturation occurs in frame stack, 1 char per band" />
      <column name="ra_pm" type="double precision" unit="deg" ucd="" description="Right ascension at epoch MJD=55400.0 (2010.5589) from pff model incl. motion" />
      <column name="dec_pm" type="double precision" unit="deg" ucd="" description="Declination at epoch MJD=55400.0 (2010.5589) from pff model incl. motion" />
      <column name="sigra_pm" type="double precision" unit="arcsec" ucd="" description="One-sigma uncertainty in RA from pff model incl. motion" />
      <column name="sigdec_pm" type="double precision" unit="arcsec" ucd="" description="One-sigma uncertainty in DEC  from pff model incl. motion" />
      <column name="sigradec_pm" type="double precision" unit="arcsec" ucd="" description="The co-sigma of the equatorial position uncertainties from ppf model incl motion" />
      <column name="pmra" type="integer" unit="maspyr" ucd="" description="Apparent motion in RA" />
      <column name="sigpmra" type="integer" unit="maspyr" ucd="" description="Uncertainty in the RA motion estimate" />
      <column name="pmdec" type="integer" unit="maspyr" ucd="" description="Apparent motion in Dec" />
      <column name="sigpmdec" type="integer" unit="maspyr" ucd="" description="Uncertainty in the Dec  motion estimate" />
      <column name="w1rchi2_pm" type="double precision" unit="" ucd="" description="Reduced chi^2 of the W1 profile-fit photometry measurement including motion est" />
      <column name="w2rchi2_pm" type="double precision" unit="" ucd="" description="Reduced chi^2 of the W2 profile-fit photometry measurement including motion est" />
      <column name="w3rchi2_pm" type="double precision" unit="" ucd="" description="Reduced chi^2 of the W3 profile-fit photometry measurement including motion est" />
      <column name="w4rchi2_pm" type="double precision" unit="" ucd="" description="Reduced chi^2 of the W4 profile-fit photometry measurement including motion est" />
      <column name="rchi2_pm" type="double precision" unit="" ucd="" description="Combined Reduced chi^2 in all bands for the pff photometry includes src motion" />
      <column name="pmcode" type="text" unit="" ucd="" description="Motion estimate quality code" />
      <column name="cc_flags" type="text" unit="" ucd="" description="prioritized artifacts affecting the source in each band" />
      <column name="rel" type="text" unit="" ucd="" description="Small separation multiple detection flag" />
      <column name="ext_flg" type="integer" unit="" ucd="" description="probability that source morphology is not consistent with single PSF" />
      <column name="var_flg" type="text" unit="" ucd="" description="probability that flux varied in any band greater than amount expected from unc.s" />
      <column name="ph_qual" type="text" unit="" ucd="" description="photometric quality of each band (A=highest, U=upper limit)" />
      <column name="det_bit" type="integer" unit="" ucd="" description="bit-encoded integer indicating detection for each band" />
      <column name="moon_lev" type="text" unit="" ucd="" description="level of moon contamination in coadd (ceiling(#frmmoon/#frames*10)), 1 per band" />
      <column name="w1nm" type="integer" unit="" ucd="" description="number of profile-fit flux measurements for source with SNR >= 3, band 1" />
      <column name="w1m" type="integer" unit="" ucd="" description="number of profile-fit flux measurements for source, band 1" />
      <column name="w2nm" type="integer" unit="" ucd="" description="number of profile-fit flux measurements for source with SNR >= 3, band 2" />
      <column name="w2m" type="integer" unit="" ucd="" description="number of profile-fit flux measurements for source, band 2" />
      <column name="w3nm" type="integer" unit="" ucd="" description="number of profile-fit flux measurements for source with SNR >= 3, band 3" />
      <column name="w3m" type="integer" unit="" ucd="" description="number of profile-fit flux measurements for source, band 3" />
      <column name="w4nm" type="integer" unit="" ucd="" description="number of profile-fit flux measurements for source with SNR >= 3, band 4" />
      <column name="w4m" type="integer" unit="" ucd="" description="number of profile-fit flux measurements for source, band 4" />
      <column name="w1cov" type="double precision" unit="" ucd="" description="mean coverage depth, band 1" />
      <column name="w2cov" type="double precision" unit="" ucd="" description="mean coverage depth, band 2" />
      <column name="w3cov" type="double precision" unit="" ucd="" description="mean coverage depth, band 3" />
      <column name="w4cov" type="double precision" unit="" ucd="" description="mean coverage depth, band 4" />
      <column name="w1cc_map" type="integer" unit="" ucd="" description="contamination and confusion bit array for the source in band 1" />
      <column name="w1cc_map_str" type="text" unit="" ucd="" description="contamination and confusion character array for the source in band 1" />
      <column name="w2cc_map" type="integer" unit="" ucd="" description="contamination and confusion bit array for the source in band 2" />
      <column name="w2cc_map_str" type="text" unit="" ucd="" description="contamination and confusion character array for the source in band 2" />
      <column name="w3cc_map" type="integer" unit="" ucd="" description="contamination and confusion bit array for the source in band 3" />
      <column name="w3cc_map_str" type="text" unit="" ucd="" description="contamination and confusion character array for the source in band 3" />
      <column name="w4cc_map" type="integer" unit="" ucd="" description="contamination and confusion bit array for the source in band 4" />
      <column name="w4cc_map_str" type="text" unit="" ucd="" description="contamination and confusion character array for the source in band 4" />
      <column name="best_use_cntr" type="bigint" unit="" ucd="" description="'cntr' of source to use from 'best' duplicate resolution group for this source" />
      <column name="ngrp" type="integer" unit="" ucd="" description="number of additional duplicate resolution groups in which this source resides" />
      <column name="w1flux" type="double precision" unit="dn" ucd="" description="profile-fit photometry raw flux, band 1" />
      <column name="w1sigflux" type="double precision" unit="dn" ucd="" description="profile-fit photometry raw flux uncertainty, band 1" />
      <column name="w1sky" type="double precision" unit="dn" ucd="" description="sky background value, band 1" />
      <column name="w1sigsk" type="double precision" unit="dn" ucd="" description="sky background value uncertainty, band 1" />
      <column name="w1conf" type="double precision" unit="dn" ucd="" description="sky confusion based on the uncertainty images, band 1" />
      <column name="w2flux" type="double precision" unit="dn" ucd="" description="profile-fit photometry raw flux, band 2" />
      <column name="w2sigflux" type="double precision" unit="dn" ucd="" description="profile-fit photometry raw flux uncertainty, band 2" />
      <column name="w2sky" type="double precision" unit="dn" ucd="" description="sky background value, band 2" />
      <column name="w2sigsk" type="double precision" unit="dn" ucd="" description="sky background value uncertainty, band 2" />
      <column name="w2conf" type="double precision" unit="dn" ucd="" description="sky confusion based on the uncertainty images, band 2" />
      <column name="w3flux" type="double precision" unit="dn" ucd="" description="profile-fit photometry raw flux, band 3" />
      <column name="w3sigflux" type="double precision" unit="dn" ucd="" description="profile-fit photometry raw flux uncertainty, band 3" />
      <column name="w3sky" type="double precision" unit="dn" ucd="" description="sky background value, band 3" />
      <column name="w3sigsk" type="double precision" unit="dn" ucd="" description="sky background value uncertainty, band 3" />
      <column name="w3conf" type="double precision" unit="dn" ucd="" description="sky confusion based on the uncertainty images, band 3" />
      <column name="w4flux" type="double precision" unit="dn" ucd="" description="profile-fit photometry raw flux, band 4" />
      <column name="w4sigflux" type="double precision" unit="dn" ucd="" description="profile-fit photometry raw flux uncertainty, band 4" />
      <column name="w4sky" type="double precision" unit="dn" ucd="" description="sky background value, band 4" />
      <column name="w4sigsk" type="double precision" unit="dn" ucd="" description="sky background value uncertainty, band 4" />
      <column name="w4conf" type="double precision" unit="dn" ucd="" description="sky confusion based on the uncertainty images, band 4" />
      <column name="w1mag" type="double precision" unit="mag" ucd="" description="instrumental standard aperture mag w/ aperture correction applied, band 1" />
      <column name="w1sigm" type="double precision" unit="mag" ucd="" description="instrumental standard aperture mag uncertainty, band 1" />
      <column name="w1flg" type="integer" unit="" ucd="" description="instrumental standard aperture flag, band 1" />
      <column name="w1mcor" type="double precision" unit="mag" ucd="" description="instrumental aperture correction, band 1, standard aperture" />
      <column name="w2mag" type="double precision" unit="mag" ucd="" description="instrumental standard aperture mag w/ aperture correction applied, band 2" />
      <column name="w2sigm" type="double precision" unit="mag" ucd="" description="instrumental standard aperture mag uncertainty, band 2" />
      <column name="w2flg" type="integer" unit="" ucd="" description="instrumental standard aperture flag, band 2" />
      <column name="w2mcor" type="double precision" unit="mag" ucd="" description="instrumental aperture correction, band 2, standard aperture" />
      <column name="w3mag" type="double precision" unit="mag" ucd="" description="instrumental standard aperture mag w/ aperture correction applied, band 3" />
      <column name="w3sigm" type="double precision" unit="mag" ucd="" description="instrumental standard aperture mag uncertainty, band 3" />
      <column name="w3flg" type="integer" unit="" ucd="" description="instrumental standard aperture flag, band 3" />
      <column name="w3mcor" type="double precision" unit="mag" ucd="" description="instrumental aperture correction, band 3, standard aperture" />
      <column name="w4mag" type="double precision" unit="mag" ucd="" description="instrumental standard aperture mag w/ aperture correction applied, band 4" />
      <column name="w4sigm" type="double precision" unit="mag" ucd="" description="instrumental standard aperture mag uncertainty, band 4" />
      <column name="w4flg" type="integer" unit="" ucd="" description="instrumental standard aperture flag, band 4" />
      <column name="w4mcor" type="double precision" unit="mag" ucd="" description="instrumental aperture correction, band 4, standard aperture" />
      <column name="w1mag_1" type="double precision" unit="mag" ucd="" description="aperture 1 instrumental aperture mag, band 1" />
      <column name="w1sigm_1" type="double precision" unit="mag" ucd="" description="aperture 1 instrumental aperture mag uncertainty, band 1" />
      <column name="w1flg_1" type="integer" unit="" ucd="" description="aperture 1 instrumental aperture flag, band 1" />
      <column name="w2mag_1" type="double precision" unit="mag" ucd="" description="aperture 1 instrumental aperture mag, band 2" />
      <column name="w2sigm_1" type="double precision" unit="mag" ucd="" description="aperture 1 instrumental aperture mag uncertainty, band 2" />
      <column name="w2flg_1" type="integer" unit="" ucd="" description="aperture 1 instrumental aperture flag, band 2" />
      <column name="w3mag_1" type="double precision" unit="mag" ucd="" description="aperture 1 instrumental aperture mag, band 3" />
      <column name="w3sigm_1" type="double precision" unit="mag" ucd="" description="aperture 1 instrumental aperture mag uncertainty, band 3" />
      <column name="w3flg_1" type="integer" unit="" ucd="" description="aperture 1 instrumental aperture flag, band 3" />
      <column name="w4mag_1" type="double precision" unit="mag" ucd="" description="aperture 1 instrumental aperture mag, band 4" />
      <column name="w4sigm_1" type="double precision" unit="mag" ucd="" description="aperture 1 instrumental aperture mag uncertainty, band 4" />
      <column name="w4flg_1" type="integer" unit="" ucd="" description="aperture 1 instrumental aperture flag, band 4" />
      <column name="w1mag_2" type="double precision" unit="mag" ucd="" description="aperture 2 instrumental aperture mag, band 1" />
      <column name="w1sigm_2" type="double precision" unit="mag" ucd="" description="aperture 2 instrumental aperture mag uncertainty, band 1" />
      <column name="w1flg_2" type="integer" unit="" ucd="" description="aperture 2 instrumental aperture flag, band 1" />
      <column name="w2mag_2" type="double precision" unit="mag" ucd="" description="aperture 2 instrumental aperture mag, band 2" />
      <column name="w2sigm_2" type="double precision" unit="mag" ucd="" description="aperture 2 instrumental aperture mag uncertainty, band 2" />
      <column name="w2flg_2" type="integer" unit="" ucd="" description="aperture 2 instrumental aperture flag, band 2" />
      <column name="w3mag_2" type="double precision" unit="mag" ucd="" description="aperture 2 instrumental aperture mag, band 3" />
      <column name="w3sigm_2" type="double precision" unit="mag" ucd="" description="aperture 2 instrumental aperture mag uncertainty, band 3" />
      <column name="w3flg_2" type="integer" unit="" ucd="" description="aperture 2 instrumental aperture flag, band 3" />
      <column name="w4mag_2" type="double precision" unit="mag" ucd="" description="aperture 2 instrumental aperture mag, band 4" />
      <column name="w4sigm_2" type="double precision" unit="mag" ucd="" description="aperture 2 instrumental aperture mag uncertainty, band 4" />
      <column name="w4flg_2" type="integer" unit="" ucd="" description="aperture 2 instrumental aperture flag, band 4" />
      <column name="w1mag_3" type="double precision" unit="mag" ucd="" description="aperture 3 instrumental aperture mag, band 1" />
      <column name="w1sigm_3" type="double precision" unit="mag" ucd="" description="aperture 3 instrumental aperture mag uncertainty, band 1" />
      <column name="w1flg_3" type="integer" unit="" ucd="" description="aperture 3 instrumental aperture flag, band 1" />
      <column name="w2mag_3" type="double precision" unit="mag" ucd="" description="aperture 3 instrumental aperture mag, band 2" />
      <column name="w2sigm_3" type="double precision" unit="mag" ucd="" description="aperture 3 instrumental aperture mag uncertainty, band 2" />
      <column name="w2flg_3" type="integer" unit="" ucd="" description="aperture 3 instrumental aperture flag, band 2" />
      <column name="w3mag_3" type="double precision" unit="mag" ucd="" description="aperture 3 instrumental aperture mag, band 3" />
      <column name="w3sigm_3" type="double precision" unit="mag" ucd="" description="aperture 3 instrumental aperture mag uncertainty, band 3" />
      <column name="w3flg_3" type="integer" unit="" ucd="" description="aperture 3 instrumental aperture flag, band 3" />
      <column name="w4mag_3" type="double precision" unit="mag" ucd="" description="aperture 3 instrumental aperture mag, band 4" />
      <column name="w4sigm_3" type="double precision" unit="mag" ucd="" description="aperture 3 instrumental aperture mag uncertainty, band 4" />
      <column name="w4flg_3" type="integer" unit="" ucd="" description="aperture 3 instrumental aperture flag, band 4" />
      <column name="w1mag_4" type="double precision" unit="mag" ucd="" description="aperture 4 instrumental aperture mag, band 1" />
      <column name="w1sigm_4" type="double precision" unit="mag" ucd="" description="aperture 4 instrumental aperture mag uncertainty, band 1" />
      <column name="w1flg_4" type="integer" unit="" ucd="" description="aperture 4 instrumental aperture flag, band 1" />
      <column name="w2mag_4" type="double precision" unit="mag" ucd="" description="aperture 4 instrumental aperture mag, band 2" />
      <column name="w2sigm_4" type="double precision" unit="mag" ucd="" description="aperture 4 instrumental aperture mag uncertainty, band 2" />
      <column name="w2flg_4" type="integer" unit="" ucd="" description="aperture 4 instrumental aperture flag, band 2" />
      <column name="w3mag_4" type="double precision" unit="mag" ucd="" description="aperture 4 instrumental aperture mag, band 3" />
      <column name="w3sigm_4" type="double precision" unit="mag" ucd="" description="aperture 4 instrumental aperture mag uncertainty, band 3" />
      <column name="w3flg_4" type="integer" unit="" ucd="" description="aperture 4 instrumental aperture flag, band 3" />
      <column name="w4mag_4" type="double precision" unit="mag" ucd="" description="aperture 4 instrumental aperture mag, band 4" />
      <column name="w4sigm_4" type="double precision" unit="mag" ucd="" description="aperture 4 instrumental aperture mag uncertainty, band 4" />
      <column name="w4flg_4" type="integer" unit="" ucd="" description="aperture 4 instrumental aperture flag, band 4" />
      <column name="w1mag_5" type="double precision" unit="mag" ucd="" description="aperture 5 instrumental aperture mag, band 1" />
      <column name="w1sigm_5" type="double precision" unit="mag" ucd="" description="aperture 5 instrumental aperture mag uncertainty, band 1" />
      <column name="w1flg_5" type="integer" unit="" ucd="" description="aperture 5 instrumental aperture flag, band 1" />
      <column name="w2mag_5" type="double precision" unit="mag" ucd="" description="aperture 5 instrumental aperture mag, band 2" />
      <column name="w2sigm_5" type="double precision" unit="mag" ucd="" description="aperture 5 instrumental aperture mag uncertainty, band 2" />
      <column name="w2flg_5" type="integer" unit="" ucd="" description="aperture 5 instrumental aperture flag, band 2" />
      <column name="w3mag_5" type="double precision" unit="mag" ucd="" description="aperture 5 instrumental aperture mag, band 3" />
      <column name="w3sigm_5" type="double precision" unit="mag" ucd="" description="aperture 5 instrumental aperture mag uncertainty, band 3" />
      <column name="w3flg_5" type="integer" unit="" ucd="" description="aperture 5 instrumental aperture flag, band 3" />
      <column name="w4mag_5" type="double precision" unit="mag" ucd="" description="aperture 5 instrumental aperture mag, band 4" />
      <column name="w4sigm_5" type="double precision" unit="mag" ucd="" description="aperture 5 instrumental aperture mag uncertainty, band 4" />
      <column name="w4flg_5" type="integer" unit="" ucd="" description="aperture 5 instrumental aperture flag, band 4" />
      <column name="w1mag_6" type="double precision" unit="mag" ucd="" description="aperture 6 instrumental aperture mag, band 1" />
      <column name="w1sigm_6" type="double precision" unit="mag" ucd="" description="aperture 6 instrumental aperture mag uncertainty, band 1" />
      <column name="w1flg_6" type="integer" unit="" ucd="" description="aperture 6 instrumental aperture flag, band 1" />
      <column name="w2mag_6" type="double precision" unit="mag" ucd="" description="aperture 6 instrumental aperture mag, band 2" />
      <column name="w2sigm_6" type="double precision" unit="mag" ucd="" description="aperture 6 instrumental aperture mag uncertainty, band 2" />
      <column name="w2flg_6" type="integer" unit="" ucd="" description="aperture 6 instrumental aperture flag, band 2" />
      <column name="w3mag_6" type="double precision" unit="mag" ucd="" description="aperture 6 instrumental aperture mag, band 3" />
      <column name="w3sigm_6" type="double precision" unit="mag" ucd="" description="aperture 6 instrumental aperture mag uncertainty, band 3" />
      <column name="w3flg_6" type="integer" unit="" ucd="" description="aperture 6 instrumental aperture flag, band 3" />
      <column name="w4mag_6" type="double precision" unit="mag" ucd="" description="aperture 6 instrumental aperture mag, band 4" />
      <column name="w4sigm_6" type="double precision" unit="mag" ucd="" description="aperture 6 instrumental aperture mag uncertainty, band 4" />
      <column name="w4flg_6" type="integer" unit="" ucd="" description="aperture 6 instrumental aperture flag, band 4" />
      <column name="w1mag_7" type="double precision" unit="mag" ucd="" description="aperture 7 instrumental aperture mag, band 1" />
      <column name="w1sigm_7" type="double precision" unit="mag" ucd="" description="aperture 7 instrumental aperture mag uncertainty, band 1" />
      <column name="w1flg_7" type="integer" unit="" ucd="" description="aperture 7 instrumental aperture flag, band 1" />
      <column name="w2mag_7" type="double precision" unit="mag" ucd="" description="aperture 7 instrumental aperture mag, band 2" />
      <column name="w2sigm_7" type="double precision" unit="mag" ucd="" description="aperture 7 instrumental aperture mag uncertainty, band 2" />
      <column name="w2flg_7" type="integer" unit="" ucd="" description="aperture 7 instrumental aperture flag, band 2" />
      <column name="w3mag_7" type="double precision" unit="mag" ucd="" description="aperture 7 instrumental aperture mag, band 3" />
      <column name="w3sigm_7" type="double precision" unit="mag" ucd="" description="aperture 7 instrumental aperture mag uncertainty, band 3" />
      <column name="w3flg_7" type="integer" unit="" ucd="" description="aperture 7 instrumental aperture flag, band 3" />
      <column name="w4mag_7" type="double precision" unit="mag" ucd="" description="aperture 7 instrumental aperture mag, band 4" />
      <column name="w4sigm_7" type="double precision" unit="mag" ucd="" description="aperture 7 instrumental aperture mag uncertainty, band 4" />
      <column name="w4flg_7" type="integer" unit="" ucd="" description="aperture 7 instrumental aperture flag, band 4" />
      <column name="w1mag_8" type="double precision" unit="mag" ucd="" description="aperture 8 instrumental aperture mag, band 1" />
      <column name="w1sigm_8" type="double precision" unit="mag" ucd="" description="aperture 8 instrumental aperture mag uncertainty, band 1" />
      <column name="w1flg_8" type="integer" unit="" ucd="" description="aperture 8 instrumental aperture flag, band 1" />
      <column name="w2mag_8" type="double precision" unit="mag" ucd="" description="aperture 8 instrumental aperture mag, band 2" />
      <column name="w2sigm_8" type="double precision" unit="mag" ucd="" description="aperture 8 instrumental aperture mag uncertainty, band 2" />
      <column name="w2flg_8" type="integer" unit="" ucd="" description="aperture 8 instrumental aperture flag, band 2" />
      <column name="w3mag_8" type="double precision" unit="mag" ucd="" description="aperture 8 instrumental aperture mag, band 3" />
      <column name="w3sigm_8" type="double precision" unit="mag" ucd="" description="aperture 8 instrumental aperture mag uncertainty, band 3" />
      <column name="w3flg_8" type="integer" unit="" ucd="" description="aperture 8 instrumental aperture flag, band 3" />
      <column name="w4mag_8" type="double precision" unit="mag" ucd="" description="aperture 8 instrumental aperture mag, band 4" />
      <column name="w4sigm_8" type="double precision" unit="mag" ucd="" description="aperture 8 instrumental aperture mag uncertainty, band 4" />
      <column name="w4flg_8" type="integer" unit="" ucd="" description="aperture 8 instrumental aperture flag, band 4" />
      <column name="w1magp" type="double precision" unit="mag" ucd="" description="profile-fit repeatability mag -- inverse-variance weighted mean mag, band 1" />
      <column name="w1sigp1" type="double precision" unit="mag" ucd="" description="standard deviation of population of profile-fit repeatability mag, band 1" />
      <column name="w1sigp2" type="double precision" unit="mag" ucd="" description="standard deviation of the mean of profile-fit repeatability mag, band 1" />
      <column name="w1k" type="double precision" unit="" ucd="" description="Stetson K variability index, band 1" />
      <column name="w1ndf" type="integer" unit="" ucd="" description="number degrees of freedom in variability chi^2, band 1" />
      <column name="w1mlq" type="double precision" unit="" ucd="" description="-ln(Q), where Q = 1 - P(chi^2), band 1" />
      <column name="w1mjdmin" type="double precision" unit="" ucd="" description="minimum modified Julian Date of frame extractions, band 1" />
      <column name="w1mjdmax" type="double precision" unit="" ucd="" description="maximum modified Julian Date of frame extractions, band 1" />
      <column name="w1mjdmean" type="double precision" unit="" ucd="" description="mean modified Julian Date of frame extractions, band 1" />
      <column name="w2magp" type="double precision" unit="mag" ucd="" description="profile-fit repeatability mag -- inverse-variance weighted mean mag, band 2" />
      <column name="w2sigp1" type="double precision" unit="mag" ucd="" description="standard deviation of the population of profile-fit repeatability mag, band 2" />
      <column name="w2sigp2" type="double precision" unit="mag" ucd="" description="standard deviation of the mean of profile-fit repeatability mag, band 2" />
      <column name="w2k" type="double precision" unit="" ucd="" description="Stetson K variability index, band 2" />
      <column name="w2ndf" type="integer" unit="" ucd="" description="number degrees of freedom in variability chi^2, band 2" />
      <column name="w2mlq" type="double precision" unit="" ucd="" description="-ln(Q), where Q = 1 - P(chi^2), band 2" />
      <column name="w2mjdmin" type="double precision" unit="" ucd="" description="minimum modified Julian Date of frame extractions, band 2" />
      <column name="w2mjdmax" type="double precision" unit="" ucd="" description="maximum modified Julian Date of frame extractions, band 2" />
      <column name="w2mjdmean" type="double precision" unit="" ucd="" description="mean modified Julian Date of frame extractions, band 2" />
      <column name="w3magp" type="double precision" unit="mag" ucd="" description="profile-fit repeatability mag -- inverse-variance weighted mean mag, band 3" />
      <column name="w3sigp1" type="double precision" unit="mag" ucd="" description="standard deviation of the population of profile-fit repeatability mag, band 3" />
      <column name="w3sigp2" type="double precision" unit="mag" ucd="" description="standard deviation of the mean of profile-fit repeatability mag, band 3" />
      <column name="w3k" type="double precision" unit="" ucd="" description="Stetson K variability index, band 3" />
      <column name="w3ndf" type="integer" unit="" ucd="" description="number degrees of freedom in variability chi^2, band 3" />
      <column name="w3mlq" type="double precision" unit="" ucd="" description="-ln(Q), where Q = 1 - P(chi^2), band 3" />
      <column name="w3mjdmin" type="double precision" unit="" ucd="" description="minimum modified Julian Date of frame extractions, band 3" />
      <column name="w3mjdmax" type="double precision" unit="" ucd="" description="maximum modified Julian Date of frame extractions, band 3" />
      <column name="w3mjdmean" type="double precision" unit="" ucd="" description="mean modified Julian Date of frame extractions, band 3" />
      <column name="w4magp" type="double precision" unit="mag" ucd="" description="profile-fit repeatability mag -- inverse-variance weighted mean mag, band 4" />
      <column name="w4sigp1" type="double precision" unit="mag" ucd="" description="standard deviation of the population of profile-fit repeatability mag, band 4" />
      <column name="w4sigp2" type="double precision" unit="mag" ucd="" description="standard deviation of the mean of profile-fit repeatability mag, band 4" />
      <column name="w4k" type="double precision" unit="" ucd="" description="Stetson K variability index, band 4" />
      <column name="w4ndf" type="integer" unit="" ucd="" description="number degrees of freedom in variability chi^2, band 4" />
      <column name="w4mlq" type="double precision" unit="" ucd="" description="-ln(Q), where Q = 1 - P(chi^2), band 4" />
      <column name="w4mjdmin" type="double precision" unit="" ucd="" description="minimum modified Julian Date of frame extractions, band 4" />
      <column name="w4mjdmax" type="double precision" unit="" ucd="" description="maximum modified Julian Date of frame extractions, band 4" />
      <column name="w4mjdmean" type="double precision" unit="" ucd="" description="mean modified Julian Date of frame extractions, band 4" />
      <column name="rho12" type="integer" unit="percent" ucd="" description="band 1 - band 2 correlation coefficient" />
      <column name="rho23" type="integer" unit="percent" ucd="" description="band 2 - band 3 correlation coefficient" />
      <column name="rho34" type="integer" unit="percent" ucd="" description="band 3 - band 4 correlation coefficient" />
      <column name="q12" type="integer" unit="" ucd="" description="-log10(1 - P(rho12)), given no real correlation" />
      <column name="q23" type="integer" unit="" ucd="" description="-log10(1 - P(rho23)), given no real correlation" />
      <column name="q34" type="integer" unit="" ucd="" description="-log10(1 - P(rho34)), given no real correlation" />
      <column name="xscprox" type="double precision" unit="arcsec" ucd="" description="distance between source center and XSC galaxy" />
      <column name="w1rsemi" type="double precision" unit="arcsec" ucd="" description="semi-major axis of galaxy from XSC, band 1" />
      <column name="w1ba" type="double precision" unit="" ucd="" description="axis ratio of galaxy from XSC, band 1" />
      <column name="w1pa" type="double precision" unit="deg" ucd="" description="position angle (E of N) of galaxy from XSC, band 1" />
      <column name="w1gmag" type="double precision" unit="mag" ucd="" description="elliptical aperture mag of extracted galaxy, band 1" />
      <column name="w1gerr" type="double precision" unit="mag" ucd="" description="elliptical aperture mag uncertainty of extracted galaxy, band 1" />
      <column name="w1gflg" type="integer" unit="" ucd="" description="elliptical aperture flag of extracted galaxy, band 1" />
      <column name="w2rsemi" type="double precision" unit="arcsec" ucd="" description="semi-major axis of galaxy from XSC, band 2" />
      <column name="w2ba" type="double precision" unit="" ucd="" description="axis ratio of galaxy from XSC, band 2" />
      <column name="w2pa" type="double precision" unit="deg" ucd="" description="position angle (E of N) of galaxy from XSC, band 2" />
      <column name="w2gmag" type="double precision" unit="mag" ucd="" description="elliptical aperture mag of extracted galaxy, band 2" />
      <column name="w2gerr" type="double precision" unit="mag" ucd="" description="elliptical aperture mag uncertainty of extracted galaxy, band 2" />
      <column name="w2gflg" type="integer" unit="" ucd="" description="elliptical aperture flag of extracted galaxy, band 2" />
      <column name="w3rsemi" type="double precision" unit="arcsec" ucd="" description="semi-major axis of galaxy from XSC, band 3" />
      <column name="w3ba" type="double precision" unit="" ucd="" description="axis ratio of galaxy from XSC, band 3" />
      <column name="w3pa" type="double precision" unit="deg" ucd="" description="position angle (E of N) of galaxy from XSC, band 3" />
      <column name="w3gmag" type="double precision" unit="mag" ucd="" description="elliptical aperture mag of extracted galaxy, band 3" />
      <column name="w3gerr" type="double precision" unit="mag" ucd="" description="elliptical aperture mag uncertainty of extracted galaxy, band 3" />
      <column name="w3gflg" type="integer" unit="" ucd="" description="elliptical aperture flag of extracted galaxy, band 3" />
      <column name="w4rsemi" type="double precision" unit="arcsec" ucd="" description="semi-major axis of galaxy from XSC, band 4" />
      <column name="w4ba" type="double precision" unit="" ucd="" description="axis ratio of galaxy from XSC, band 4" />
      <column name="w4pa" type="double precision" unit="deg" ucd="" description="position angle (E of N) of galaxy from XSC, band 4" />
      <column name="w4gmag" type="double precision" unit="mag" ucd="" description="elliptical aperture mag of extracted galaxy, band 4" />
      <column name="w4gerr" type="double precision" unit="mag" ucd="" description="elliptical aperture mag uncertainty of extracted galaxy, band 4" />
      <column name="w4gflg" type="integer" unit="" ucd="" description="elliptical aperture flag of extracted galaxy, band 4" />
      <column name="tmass_key" type="integer" unit="" ucd="" description="closest associated 2MASS All-Sky Release PSC key" />
      <column name="r_2mass" type="double precision" unit="arcsec" ucd="" description="radial offset between WISE src and associated 2MASS src" />
      <column name="pa_2mass" type="double precision" unit="deg" ucd="" description="position angle (E of N) of vector from WISE src to associated 2MASS src" />
      <column name="n_2mass" type="integer" unit="" ucd="" description="number of 2MASS All-Sky PSC entries found within search radius of WISE src" />
      <column name="j_m_2mass" type="double precision" unit="mag" ucd="" description="J magnitude entry of the associated 2MASS All-Sky PSC source" />
      <column name="j_msig_2mass" type="double precision" unit="mag" ucd="" description="J photometric uncertainty of the associated 2MASS All-Sky PSC source" />
      <column name="h_m_2mass" type="double precision" unit="mag" ucd="" description="H magnitude entry of the associated 2MASS All-Sky PSC source" />
      <column name="h_msig_2mass" type="double precision" unit="mag" ucd="" description="H photometric uncertainty of the associated 2MASS All-Sky PSC source" />
      <column name="k_m_2mass" type="double precision" unit="mag" ucd="" description="Ks magnitude entry of the associated 2MASS All-Sky PSC source" />
      <column name="k_msig_2mass" type="double precision" unit="mag" ucd="" description="Ks photometric uncertainty of the associated 2MASS All-Sky PSC source" />
      <column name="x" type="double precision" unit="" ucd="pos.cartesian.x" description="unit sphere (x,y,z) position x value" />
      <column name="y" type="double precision" unit="" ucd="pos.cartesian.y" description="unit sphere (x,y,z) position y value" />
      <column name="z" type="double precision" unit="" ucd="pos.cartesian.z" description="unit sphere (x,y,z) position z value" />
      <column name="spt_ind" type="integer" unit="" ucd="pos.HTM" description="spatial (x,y,z) index key" />
      <column name="htm20" type="bigint" unit="" ucd="pos.HTM" description="HTM20 spatial index key" />
   </table>

   <table id="sources" onDisk="True" adql="True">
      <column name="id" type="bigint" unit="" ucd="meta.id;meta.main"/>
      <column name="component_id" type="bigint" unit="" ucd="meta.id"/>
      <column name="wise_id" type="text" unit="" ucd="meta.id"/>
      <column name="separation" type="double precision" unit="rad" ucd="meta.id"/>

      <foreignKey source="component_id" dest="id" inTable="components"/>
      <foreignKey source="wise_id" dest="designation" inTable="allwise"/>
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