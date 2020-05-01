\connect emucat

CREATE EXTENSION postgis;
CREATE EXTENSION pg_sphere;

CREATE SCHEMA "emucat" AUTHORIZATION "admin";

CREATE TABLE emucat.mosaics (
    "id" BIGSERIAL PRIMARY KEY,
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

    unique ("image_file", "subsection")
);

CREATE TABLE emucat.sources (
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

    unique ("component_name", "ra_deg_cont", "dec_deg_cont")
);

CREATE INDEX sources_unique_index ON emucat.sources ("component_name", "ra_deg_cont", "dec_deg_cont");

ALTER TABLE emucat.sources ADD FOREIGN KEY ("mosaic_id") REFERENCES emucat.mosaics ("id") ON DELETE CASCADE;

ALTER TABLE emucat.sources OWNER TO "admin";

GRANT ALL PRIVILEGES ON DATABASE emucat TO "admin";
GRANT ALL PRIVILEGES ON DATABASE emucat TO "gavoadmin";
GRANT ALL PRIVILEGES ON DATABASE emucat TO "gavo";

GRANT CONNECT ON DATABASE emucat TO "gavoadmin";
GRANT USAGE ON SCHEMA "emucat" TO "gavoadmin";
GRANT SELECT ON TABLE emucat.mosaics TO "gavoadmin";
GRANT SELECT ON TABLE emucat.sources TO "gavoadmin";
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA emucat TO "gavoadmin";

GRANT CONNECT ON DATABASE emucat TO "gavo";
GRANT USAGE ON SCHEMA "emucat" TO "gavo";
GRANT SELECT ON TABLE emucat.mosaics TO "gavo";
GRANT SELECT ON TABLE emucat.sources TO "gavo";
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA emucat TO "gavo";

GRANT CONNECT ON DATABASE emucat TO "untrusted";
GRANT USAGE ON SCHEMA "emucat" TO "untrusted";
GRANT SELECT ON TABLE emucat.mosaics TO "untrusted";
GRANT SELECT ON TABLE emucat.sources TO "untrusted";
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA emucat TO "untrusted";