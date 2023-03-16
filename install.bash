################################################################################
#                               Install Stack
################################################################################
mkdir -p lsst_stack
cd lsst_stack

curl -OL https://raw.githubusercontent.com/lsst/lsst/main/scripts/newinstall.sh
bash newinstall.sh -cbt

source loadLSST.bash

eups distrib install -t w_latest lsst_distrib
curl -sSL https://raw.githubusercontent.com/lsst/shebangtron/main/shebangtron | python
setup lsst_distrib

cd ..


################################################################################
#                      Clone and setup example HSC data
################################################################################

git clone https://github.com/lsst/testdata_ci_hsc.git

cd testdata_ci_hsc
setup -k -r .
cd ..


