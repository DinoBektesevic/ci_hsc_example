################################################################################
#                   Disable any implicit multiprocessing
################################################################################
# This is because the stack does its own multiprocessing, so if each of those
# spawned, implicitly due to BLAS MKS OMP etc.., any number of threads things
# get out of hand quickly.
export OPENBLAS_NUM_THREADS=1
export MKL_NUM_THREADS="1"
export MKL_DYNAMIC="FALSE"
export OMP_NUM_THREADS=1


################################################################################
#                         Setup processing variables
#             (assume it's referenced from current working directory)
################################################################################
# data sources and data targets
DATA_SRC="$PWD/testdata_ci_hsc"
REPO_ROOT="butler_repo"

# collection names (logical units with which ingested and processed data are
# tagged with) are completely arbitrary, but there are some more that are used
# by convention. COLLECTION is the output collection in which the processing
# results will be put, and INPUTCOLL is the collection from which the data
# will be taken from.
COLLECTION="HSC/runs/ci_hsc"
INPUTCOLL="HSC/defaults"



################################################################################
#                       Process some data
################################################################################

# run is the command that tells it to execute, qgraph for example will create a DAG
# -d flag targets what data to process
# -b flags points to the butler config file
# --input is the "search for targeted data using this collection tag" condition
# --output is the "put whatever you produce in the butler repo with this tag"
# -p points to the pipeline defintion file - we can override/replace this
# -c are inline overrides provided for the default pipeline
# -j is number of threads
# --register-dataset-types tells the butler to compile dataset types it will
#     produce and pre-register them, which saves a lot of checks for each new
#     dataset that is produced otherwise.
pipetask --long-log --log-level=INFO run                   \
    -d "skymap='discrete/ci_hsc' AND tract=0 AND patch=69" \
    -b "$REPO_ROOT/butler.yaml"                            \
    --input "$INPUTCOLL"                                   \
    --output "$COLLECTION"                                 \
    -p "$DRP_PIPE_DIR/pipelines/HSC/DRP-ci_hsc.yaml"       \
    -c "calibrate:astrometry.maxMeanDistanceArcsec=0.025"  \
    -c "calibrate:requireAstrometry=False"                 \
    -c "calibrate:requirePhotoCal=False"                   \
    -c "makeWarp:select.maxPsfTraceRadiusDelta=0.2"        \
    -j 30                                                  \
    --register-dataset-types

