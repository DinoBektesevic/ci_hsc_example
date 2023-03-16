# Check out the help
butler --help

# Then individually check out help on each command
butler query-collections --help

# To see all the collections that were created in the processing:
butler query-collections butler_repo/

# Similarly, to see all the dataset
butler query-datasets butler_repo/

# The above commands report on all of the stuff in the data repo
# let's see how we can be a bit more targeted. Let's see what the
# availible dataset types are and then let's try to focus on a
# calibrated exposure of a ssingle visit
butler query-dataset-types butler_repo/

# Because we've valiantly been reading the help strings and not
# just blindly running commands without understanding we now know
# that all data products related to visit 903334 can be found like
# (be careful how you escape string sequences, this is literal SQL statement)
butler query-datasets --where "instrument='HSC' AND visit=903334" butler_repo/

# and we also know, from the help string, that we can add any glob-style expression
# to capture the dataset_type we want - in this case just the calibrated exposures
# for example
butler query-datasets butler_repo/ calexp --where  "instrument='HSC' AND visit=903334"

# and if we want to see where the actual file is (not that we want to do that in
# general, don't do that - leave the files where they are)
butler query-datasets butler_repo/ calexp --where  "instrument='HSC' AND visit=903334" --show-uri
