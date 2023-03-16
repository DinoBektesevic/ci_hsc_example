# CI HSC PIPELINE RUNS

Unrolled CI HSC pipeline that Vera C. Rubin Observatory DM team uses to test their packages are correct.
The pipeline should be nearly identical to [ci_hsc_gen3](https://github.com/lsst/ci_hsc_gen3) with the exception that some unecessary commands have been trimmed out. 

The pipeline demonstrates what it takes to produce the kind of datasets that could potentially be inputs for KBMOD.
The pipeline starts with raw data, as it exists the telescope and loads of calibration data that is required to correctly process these images into calibrated exposures, coadds, image differences etc.

# HOW TO - REPO

The pipeline has been unravelled so that it demonstrates what running from a terminal would look like. Starting from zero, assuming no stack has been installed or set up, the way to walk through the processing is to:

* run `source install.bash`
  Which will download and install the stack and [testdata_ci_hsc](https://github.com/lsst/testdata_ci_hsc). The [testdata_ci_hsc](https://github.com/lsst/testdata_ci_hsc) repository is an Git LFS repository that contains the minimal required dataset to fully test the Rubin Science Pipelines. To correctly retrieve this repository you are expected to have, correctly, set up [Git LFS](https://developer.lsst.io/git/git-lfs.html#configuring-git-lfs) as described in Rubin's documentation.
* run `source ingest_data.bash`
  Which will create the data repository, ingest the raw data, ingest the calibration data, ingest the pre-prepared fake processing data, ingest the reference catalogs define visits, skymaps etc.

This will provide you with a basic starting repo, on which you are free to run any kind of pipelines you wish. The files are just sets of commands one would execute in a normal bash terminal, followed by some general commentary on what their purpose is. 

The repo contains several ways to run the example CI HSC pipelines:

* `run_default_pipeline_terminal.bash` - which can be executed with `source run_default_pipeline_terminal.bash` and contains the same setup the CI HSC repo executes
* `run_default_pipeline_yaml.bash` - which takes the same default pipeline, including the config parameter overrides given to it on the terminal, and writes it in a form of `pipelines/default_ci_hsc_pipeline_definition.yaml`. In turn that pipeline inherits from the Rubin's default Data Release Production (DRP) pipeline, see [here](https://github.com/lsst/drp_pipe/blob/main/pipelines/HSC/DRP-ci_hsc.yaml), which is the DRP pipeline specialized to run on HSC. That pipeline basically executes the default full DRP pipeline, see [here](https://github.com/lsst/drp_pipe/blob/main/ingredients/DRP-full.yaml), but sets the default instrument to HSC and prevents some of the Tasks that would otherwise fail for HSC from running.

The two default pipelines produce the same data, of course, but they place it in different `collections` demonstrating how we can separate ingested and produced data, when they are of the same dataset type, when we want to run many reprocessings with different input parameters. For example, in KBMOD, this has been used to create many different image differencing templates in such a way that the template would be constructed from data **not overlapping** the observing period of the image in which the object was searched for. Otherwise these templates would contain the object itself, subsequently subtracting it from the image (this gets a bit more complicated really, but for example that's one thing you could use the collections for).

# HOW TO - BUTLER

The other two things of interest in the repository are:
* `examine_data_repo_with_butler_terminal.bash` - which is a collection of commands with which you can inspect the datasets created by the processing pipelines, query metadata and so on
* `examine_data_repo_with_butler_python.py` - which imports the `lsst.daf.butler.Butler` class, and repeats the same metadata queries, but (hopefully) demonstrates that the returned data are all Python objects, and most of them quite familiar ones - like numpy arrays, builtins etc... 