################################################################################
#                         Setup processing variables
#             (assume it's referenced from current working directory)
################################################################################
# data sources and data targets
DATA_SRC="$PWD/testdata_ci_hsc"
REPO_ROOT="butler_repo"

# collection names (logical units with which ingested and processed data are
# tagged with) are completely arbitrary, but there are some that are used by
# convention
VISIT_COLLECTION="HSC/raw/all"


################################################################################
#                  Create and ingest RAW data to a repository
################################################################################
butler create "$REPO_ROOT"

# makes sure butler understands the camera/instrument geometry and any
# specific overrides that are defined in the obs_subaru package
butler register-instrument "$REPO_ROOT" "lsst.obs.subaru.HyperSuprimeCam"

# downloads time-stampled defect masks, bad column data etc...
butler write-curated-calibrations "$REPO_ROOT" "HSC"

# creates a sky-pixelization that will be used during processing
butler register-skymap "$REPO_ROOT" -C "resources/skymap_config.py"

# Takes each raw image, translates header, registers keys in the DB, makes
# links or copies data into the repository where appropriate and in format
# that is appropriate
butler ingest-raws "$REPO_ROOT" "$DATA_SRC/raw"

# Take the ingested raw data, pointing, timestamps and skymap and define
# a "visit" to a part of the sky, record these tagged with collection
butler define-visits "$REPO_ROOT" "HSC" --collections "$VISIT_COLLECTION"


################################################################################
#                  Prepare for processing of the data 
################################################################################
# To process raws we need flats, darks, biases, masks reference
# catalogs and all kinds of other data that has been taken on the same
# night, or at some time before/later and can't be curated as a static
# dataset. We need all that too...

# register gaia catalog as a dataset with a name type pixelization scheme
butler register-dataset-type "$REPO_ROOT" "gaia_dr2_20200414" "SimpleCatalog" "htm7"
butler ingest-files --prefix "$DATA_SRC" "$REPO_ROOT" "gaia_dr2_20200414" "refcats" "$DATA_SRC/gaia_dr2_20200414.ecsv"

# Same with PanSTARSS - Gaia is for astrometry, PS for photometry
butler register-dataset-type "$REPO_ROOT" "ps1_pv3_3pi_20170110" "SimpleCatalog" "htm7"
butler ingest-files --prefix "$DATA_SRC" "$REPO_ROOT" "ps1_pv3_3pi_20170110" "refcats" "$DATA_SRC/ps1_pv3_3pi_20170110.ecsv"

# bright object masks, reference catalogs, and master calibration files
# this is a bit of a cheat on ci_hsc part as these are pre-generated
butler import "$REPO_ROOT" "$DATA_SRC" --export-file "resources/external.yaml"
butler import "$REPO_ROOT" "$DATA_SRC" --export-file "resources/external_jointcal.yaml"
butler import "$REPO_ROOT" "$DATA_SRC" --export-file "resources/external_fakes.yaml"
