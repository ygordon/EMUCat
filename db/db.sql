\connect emucat

CREATE EXTENSION postgis;
CREATE EXTENSION pg_sphere;

CREATE SCHEMA "emucat" AUTHORIZATION "admin";


CREATE TABLE emucat.source_extraction_regions (
    "id" BIGSERIAL PRIMARY KEY,
    "name" varchar NOT NULL,
    "extent" sbox NOT NULL,
    "centre" spoint NOT NULL,

    unique ("name")
);

CREATE TABLE emucat.scheduling_blocks (
    "id" BIGSERIAL PRIMARY KEY,
    "sb_num" bigint NOT NULL,

    unique ("sb_num")
);

CREATE TABLE emucat.mosaic_prerequisites (
    "id" BIGSERIAL PRIMARY KEY,
    "sb_id" bigint NOT NULL,
    "ser_id" bigint NOT NULL,

    unique ("sb_id", "ser_id")
);

ALTER TABLE emucat.mosaic_prerequisites ADD FOREIGN KEY ("sb_id") REFERENCES emucat.scheduling_blocks ("id") ON DELETE CASCADE;
ALTER TABLE emucat.mosaic_prerequisites ADD FOREIGN KEY ("ser_id") REFERENCES emucat.source_extraction_regions ("id") ON DELETE CASCADE;


CREATE TABLE emucat.mosaics (
    "id" BIGSERIAL PRIMARY KEY,
    "ser_id" bigint NOT NULL,
    "table_version" varchar NOT NULL,
    "image_file" varchar NOT NULL,
    "flag_subsection" boolean DEFAULT False NOT NULL,
    "subsection" varchar NOT NULL,
    "flag_statsec" boolean DEFAULT False NOT NULL,
    "statsec" varchar NOT NULL,
    "search_type" varchar NOT NULL,
    "flag_negative" boolean DEFAULT False NOT NULL,
    "flag_baseline" boolean DEFAULT False NOT NULL,
    "flag_robuststats" boolean DEFAULT False NOT NULL,
    "flag_fdr" boolean DEFAULT False NOT NULL,
    "threshold" double precision NOT NULL,
    "flag_growth" boolean DEFAULT False NOT NULL,
    "growth_threshold" double precision NOT NULL,
    "min_pix" integer NOT NULL,
    "min_channels" integer NOT NULL,
    "min_voxels" integer NOT NULL,
    "flag_adjacent" boolean DEFAULT False NOT NULL,
    "thresh_velocity" double precision NOT NULL,
    "flag_rejectbeforemerge" boolean DEFAULT False NOT NULL,
    "flag_twostagemerging" boolean DEFAULT False NOT NULL,
    "pixel_centre" varchar NOT NULL,
    "flag_smooth" boolean DEFAULT False NOT NULL,
    "flag_atrous" boolean DEFAULT False NOT NULL,
    "reference_frequency" double precision NOT NULL,
    "threshold_actual" double precision NOT NULL,

    unique ("ser_id", "subsection")
);

ALTER TABLE emucat.mosaics ADD FOREIGN KEY ("ser_id") REFERENCES emucat.source_extraction_regions ("id") ON DELETE CASCADE;

CREATE TABLE emucat.components (
    "id" BIGSERIAL PRIMARY KEY,
    "mosaic_id" bigint NOT NULL,
    "island_id" varchar NOT NULL,
    "component_id" varchar NOT NULL,
    "component_name" varchar NOT NULL,
    "ra_hms_cont" varchar NOT NULL,
    "dec_hms_cont" varchar NOT NULL,
    "ra_deg_cont" double precision NOT NULL,
    "dec_deg_cont" double precision NOT NULL,
    "ra_err" double precision NOT NULL,
    "dec_err" double precision NOT NULL,
    "freq" double precision NOT NULL,
    "flux_peak" double precision NOT NULL,
    "flux_peak_err" double precision NOT NULL,
    "flux_int" double precision NOT NULL,
    "flux_int_err" double precision NOT NULL,
    "maj_axis" double precision NOT NULL,
    "min_axis" double precision NOT NULL,
    "pos_ang" double precision NOT NULL,
    "maj_axis_err" double precision NOT NULL,
    "min_axis_err" double precision NOT NULL,
    "pos_ang_err" double precision NOT NULL,
    "maj_axis_deconv" double precision NOT NULL,
    "min_axis_deconv" double precision NOT NULL,
    "pos_ang_deconv" double precision NOT NULL,
    "maj_axis_deconv_err" double precision NOT NULL,
    "min_axis_deconv_err" double precision NOT NULL,
    "pos_ang_deconv_err" double precision NOT NULL,
    "chi_squared_fit" double precision NOT NULL,
    "rms_fit_gauss" double precision NOT NULL,
    "spectral_index" double precision NOT NULL,
    "spectral_curvature" double precision NOT NULL,
    "spectral_index_err" double precision NOT NULL,
    "spectral_curvature_err" double precision NOT NULL,
    "rms_image" double precision NOT NULL,
    "has_siblings" integer NOT NULL,
    "fit_is_estimate" integer NOT NULL,
    "spectral_index_from_tt" integer NOT NULL,
    "flag_c4" integer NOT NULL,
    "comment" varchar NOT NULL,

    unique ("mosaic_id", "component_name", "ra_deg_cont", "dec_deg_cont")
);

CREATE INDEX components_unique_index ON emucat.components ("component_name", "ra_deg_cont", "dec_deg_cont");
ALTER TABLE emucat.components ADD FOREIGN KEY ("mosaic_id") REFERENCES emucat.mosaics ("id") ON DELETE CASCADE;

CREATE TABLE emucat.allwise (
    "designation" varchar PRIMARY KEY,
    "ra_dec" spoint NOT NULL
     ra numeric(10,7),
    "dec" numeric(9,7),
    sigra numeric(7,4),
    sigdec numeric(7,4),
    sigradec numeric(8,4),
    glon numeric(10,7),
    glat numeric(9,7),
    elon numeric(10,7),
    elat numeric(9,7),
    wx numeric(7,3),
    wy numeric(7,3),
    cntr bigint,
    source_id character(28),
    coadd_id character(20),
    src integer,
    w1mpro numeric(5,3),
    w1sigmpro numeric(4,3),
    w1snr numeric(7,1),
    w1rchi2 real,
    w2mpro numeric(5,3),
    w2sigmpro numeric(4,3),
    w2snr numeric(7,1),
    w2rchi2 real,
    w3mpro numeric(5,3),
    w3sigmpro numeric(4,3),
    w3snr numeric(7,1),
    w3rchi2 real,
    w4mpro numeric(5,3),
    w4sigmpro numeric(4,3),
    w4snr numeric(7,1),
    w4rchi2 real,
    rchi2 real,
    nb integer,
    na integer,
    w1sat numeric(4,3),
    w2sat numeric(4,3),
    w3sat numeric(4,3),
    w4sat numeric(4,3),
    satnum character(4),
    ra_pm numeric(10,7),
    dec_pm numeric(9,7),
    sigra_pm numeric(7,4),
    sigdec_pm numeric(7,4),
    sigradec_pm numeric(8,4),
    pmra integer,
    sigpmra integer,
    pmdec integer,
    sigpmdec integer,
    w1rchi2_pm real,
    w2rchi2_pm real,
    w3rchi2_pm real,
    w4rchi2_pm real,
    rchi2_pm real,
    pmcode character(5),
    cc_flags character(4),
    rel character(1),
    ext_flg integer,
    var_flg character(4),
    ph_qual character(4),
    det_bit integer,
    moon_lev character(4),
    w1nm integer,
    w1m integer,
    w2nm integer,
    w2m integer,
    w3nm integer,
    w3m integer,
    w4nm integer,
    w4m integer,
    w1cov numeric(6,3),
    w2cov numeric(6,3),
    w3cov numeric(6,3),
    w4cov numeric(6,3),
    w1cc_map integer,
    w1cc_map_str character(9),
    w2cc_map integer,
    w2cc_map_str character(9),
    w3cc_map integer,
    w3cc_map_str character(9),
    w4cc_map integer,
    w4cc_map_str character(9),
    best_use_cntr bigint,
    ngrp smallint,
    w1flux real,
    w1sigflux real,
    w1sky numeric(8,3),
    w1sigsk numeric(6,3),
    w1conf numeric(8,3),
    w2flux real,
    w2sigflux real,
    w2sky numeric(8,3),
    w2sigsk numeric(6,3),
    w2conf numeric(8,3),
    w3flux real,
    w3sigflux real,
    w3sky numeric(8,3),
    w3sigsk numeric(6,3),
    w3conf numeric(8,3),
    w4flux real,
    w4sigflux real,
    w4sky numeric(8,3),
    w4sigsk numeric(6,3),
    w4conf numeric(8,3),
    w1mag numeric(5,3),
    w1sigm numeric(4,3),
    w1flg integer,
    w1mcor numeric(4,3),
    w2mag numeric(5,3),
    w2sigm numeric(4,3),
    w2flg integer,
    w2mcor numeric(4,3),
    w3mag numeric(5,3),
    w3sigm numeric(4,3),
    w3flg integer,
    w3mcor numeric(4,3),
    w4mag numeric(5,3),
    w4sigm numeric(4,3),
    w4flg integer,
    w4mcor numeric(4,3),
    w1mag_1 numeric(5,3),
    w1sigm_1 numeric(4,3),
    w1flg_1 integer,
    w2mag_1 numeric(5,3),
    w2sigm_1 numeric(4,3),
    w2flg_1 integer,
    w3mag_1 numeric(5,3),
    w3sigm_1 numeric(4,3),
    w3flg_1 integer,
    w4mag_1 numeric(5,3),
    w4sigm_1 numeric(4,3),
    w4flg_1 integer,
    w1mag_2 numeric(5,3),
    w1sigm_2 numeric(4,3),
    w1flg_2 integer,
    w2mag_2 numeric(5,3),
    w2sigm_2 numeric(4,3),
    w2flg_2 integer,
    w3mag_2 numeric(5,3),
    w3sigm_2 numeric(4,3),
    w3flg_2 integer,
    w4mag_2 numeric(5,3),
    w4sigm_2 numeric(4,3),
    w4flg_2 integer,
    w1mag_3 numeric(5,3),
    w1sigm_3 numeric(4,3),
    w1flg_3 integer,
    w2mag_3 numeric(5,3),
    w2sigm_3 numeric(4,3),
    w2flg_3 integer,
    w3mag_3 numeric(5,3),
    w3sigm_3 numeric(4,3),
    w3flg_3 integer,
    w4mag_3 numeric(5,3),
    w4sigm_3 numeric(4,3),
    w4flg_3 integer,
    w1mag_4 numeric(5,3),
    w1sigm_4 numeric(4,3),
    w1flg_4 integer,
    w2mag_4 numeric(5,3),
    w2sigm_4 numeric(4,3),
    w2flg_4 integer,
    w3mag_4 numeric(5,3),
    w3sigm_4 numeric(4,3),
    w3flg_4 integer,
    w4mag_4 numeric(5,3),
    w4sigm_4 numeric(4,3),
    w4flg_4 integer,
    w1mag_5 numeric(5,3),
    w1sigm_5 numeric(4,3),
    w1flg_5 integer,
    w2mag_5 numeric(5,3),
    w2sigm_5 numeric(4,3),
    w2flg_5 integer,
    w3mag_5 numeric(5,3),
    w3sigm_5 numeric(4,3),
    w3flg_5 integer,
    w4mag_5 numeric(5,3),
    w4sigm_5 numeric(4,3),
    w4flg_5 integer,
    w1mag_6 numeric(5,3),
    w1sigm_6 numeric(4,3),
    w1flg_6 integer,
    w2mag_6 numeric(5,3),
    w2sigm_6 numeric(4,3),
    w2flg_6 integer,
    w3mag_6 numeric(5,3),
    w3sigm_6 numeric(4,3),
    w3flg_6 integer,
    w4mag_6 numeric(5,3),
    w4sigm_6 numeric(4,3),
    w4flg_6 integer,
    w1mag_7 numeric(5,3),
    w1sigm_7 numeric(4,3),
    w1flg_7 integer,
    w2mag_7 numeric(5,3),
    w2sigm_7 numeric(4,3),
    w2flg_7 integer,
    w3mag_7 numeric(5,3),
    w3sigm_7 numeric(4,3),
    w3flg_7 integer,
    w4mag_7 numeric(5,3),
    w4sigm_7 numeric(4,3),
    w4flg_7 integer,
    w1mag_8 numeric(5,3),
    w1sigm_8 numeric(4,3),
    w1flg_8 integer,
    w2mag_8 numeric(5,3),
    w2sigm_8 numeric(4,3),
    w2flg_8 integer,
    w3mag_8 numeric(5,3),
    w3sigm_8 numeric(4,3),
    w3flg_8 integer,
    w4mag_8 numeric(5,3),
    w4sigm_8 numeric(4,3),
    w4flg_8 integer,
    w1magp numeric(5,3),
    w1sigp1 numeric(5,3),
    w1sigp2 numeric(5,3),
    w1k numeric(4,3),
    w1ndf integer,
    w1mlq numeric(4,2),
    w1mjdmin numeric(13,8),
    w1mjdmax numeric(13,8),
    w1mjdmean numeric(13,8),
    w2magp numeric(5,3),
    w2sigp1 numeric(5,3),
    w2sigp2 numeric(5,3),
    w2k numeric(4,3),
    w2ndf integer,
    w2mlq numeric(4,2),
    w2mjdmin numeric(13,8),
    w2mjdmax numeric(13,8),
    w2mjdmean numeric(13,8),
    w3magp numeric(5,3),
    w3sigp1 numeric(5,3),
    w3sigp2 numeric(5,3),
    w3k numeric(4,3),
    w3ndf integer,
    w3mlq numeric(4,2),
    w3mjdmin numeric(13,8),
    w3mjdmax numeric(13,8),
    w3mjdmean numeric(13,8),
    w4magp numeric(5,3),
    w4sigp1 numeric(5,3),
    w4sigp2 numeric(5,3),
    w4k numeric(4,3),
    w4ndf integer,
    w4mlq numeric(4,2),
    w4mjdmin numeric(13,8),
    w4mjdmax numeric(13,8),
    w4mjdmean numeric(13,8),
    rho12 integer,
    rho23 integer,
    rho34 integer,
    q12 integer,
    q23 integer,
    q34 integer,
    xscprox numeric(7,2),
    w1rsemi numeric(7,2),
    w1ba numeric(3,2),
    w1pa numeric(5,2),
    w1gmag numeric(5,3),
    w1gerr numeric(4,3),
    w1gflg integer,
    w2rsemi numeric(7,2),
    w2ba numeric(3,2),
    w2pa numeric(5,2),
    w2gmag numeric(5,3),
    w2gerr numeric(4,3),
    w2gflg integer,
    w3rsemi numeric(7,2),
    w3ba numeric(3,2),
    w3pa numeric(5,2),
    w3gmag numeric(5,3),
    w3gerr numeric(4,3),
    w3gflg integer,
    w4rsemi numeric(7,2),
    w4ba numeric(3,2),
    w4pa numeric(5,2),
    w4gmag numeric(5,3),
    w4gerr numeric(4,3),
    w4gflg integer,
    tmass_key integer,
    r_2mass numeric(5,3),
    pa_2mass numeric(4,1),
    n_2mass integer,
    j_m_2mass numeric(5,3),
    j_msig_2mass numeric(4,3),
    h_m_2mass numeric(5,3),
    h_msig_2mass numeric(4,3),
    k_m_2mass numeric(5,3),
    k_msig_2mass numeric(4,3),
    x numeric(17,16),
    y numeric(17,16),
    z numeric(17,16),
    spt_ind integer,
    htm20 bigint,
);

CREATE INDEX allwise_unique_index ON emucat.allwise USING GIST ("ra_dec");

CREATE TABLE emucat.sources (
    "id" BIGSERIAL PRIMARY KEY,
    "component_id" bigint NOT NULL,
    "wise_id" varchar NOT NULL,
    "separation" double precision NOT NULL,

    unique ("component_id", "wise_id")
);

ALTER TABLE emucat.sources ADD FOREIGN KEY ("component_id") REFERENCES emucat.components ("id") ON DELETE CASCADE;
ALTER TABLE emucat.sources ADD FOREIGN KEY ("wise_id") REFERENCES emucat.allwise ("designation") ON DELETE CASCADE;

ALTER TABLE emucat.components OWNER TO "admin";

GRANT ALL PRIVILEGES ON DATABASE emucat TO "admin";
GRANT ALL PRIVILEGES ON DATABASE emucat TO "gavoadmin";
GRANT ALL PRIVILEGES ON DATABASE emucat TO "gavo";

GRANT CONNECT ON DATABASE emucat TO "gavoadmin";
GRANT USAGE ON SCHEMA "emucat" TO "gavoadmin";
GRANT SELECT ON TABLE emucat.source_extraction_regions TO "gavoadmin";
GRANT SELECT ON TABLE emucat.scheduling_blocks TO "gavoadmin";
GRANT SELECT ON TABLE emucat.mosaic_prerequisites TO "gavoadmin";
GRANT SELECT ON TABLE emucat.mosaics TO "gavoadmin";
GRANT SELECT ON TABLE emucat.components TO "gavoadmin";
GRANT SELECT ON TABLE emucat.sources TO "gavoadmin";
GRANT SELECT ON TABLE emucat.allwise TO "gavoadmin";
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA emucat TO "gavoadmin";

GRANT CONNECT ON DATABASE emucat TO "gavo";
GRANT USAGE ON SCHEMA "emucat" TO "gavo";
GRANT SELECT ON TABLE emucat.source_extraction_regions TO "gavo";
GRANT SELECT ON TABLE emucat.scheduling_blocks TO "gavo";
GRANT SELECT ON TABLE emucat.mosaic_prerequisites TO "gavo";
GRANT SELECT ON TABLE emucat.mosaics TO "gavo";
GRANT SELECT ON TABLE emucat.components TO "gavo";
GRANT SELECT ON TABLE emucat.sources TO "gavo";
GRANT SELECT ON TABLE emucat.allwise TO "gavo";
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA emucat TO "gavo";

GRANT CONNECT ON DATABASE emucat TO "untrusted";
GRANT USAGE ON SCHEMA "emucat" TO "untrusted";
GRANT SELECT ON TABLE emucat.source_extraction_regions TO "untrusted";
GRANT SELECT ON TABLE emucat.scheduling_blocks TO "untrusted";
GRANT SELECT ON TABLE emucat.mosaic_prerequisites TO "untrusted";
GRANT SELECT ON TABLE emucat.mosaics TO "untrusted";
GRANT SELECT ON TABLE emucat.components TO "untrusted";
GRANT SELECT ON TABLE emucat.sources TO "untrusted";
GRANT SELECT ON TABLE emucat.allwise TO "untrusted";
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA emucat TO "untrusted";