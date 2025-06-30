#!/bin/bash

# =======================================================================================
#  Download ELM singe-site driver files
#  Source: GitHub
#  Source URL: https://github.com/fmyuan/pt-e3sm-inputdata
#  Source Data URL: https://github.com/fmyuan/pt-e3sm-inputdata/archive/refs/heads/master.zip
# =======================================================================================

# =======================================================================================
# How to use this with the Docker container, run:
# docker run -t -i --hostname=docker --user $(id -u):$(id -g) -v /Users/sserbin/Data/testing:/inputdata \
# -v /Users/sserbin/Data/GitHub/fasst_simulation_tools/met_scripts/ngeearctic:/scripts \
# test_ngee_elm /scripts/download_elm_singlesite_forcing_data.sh
#
# =======================================================================================

# =======================================================================================
# USER OPTIONS
# path to "single_site" directory within main CESM data directory located on the host
# machine
cesm_data_dir=/home/${USER}/inputdata
mkdir -p ${cesm_data_dir}
# =======================================================================================

# =======================================================================================
echo "*** Downloading and extracting forcing data ***"

cd ${cesm_data_dir}
# remove any old files before downloading updated met data
rm -rf *
# download the met data
wget https://github.com/fmyuan/pt-e3sm-inputdata/archive/refs/heads/master.zip
unzip master.zip
cd pt-e3sm-inputdata-master
mv * ../
cd ..

echo "*** Removing zip file ***"
rm -rf pt-e3sm-inputdata-master
#rm -f ${cesm_data_dir}/master.zip
rm -f master.zip

# go in and extract remaining tar files
cd ${cesm_data_dir}
sh ./unpack.sh
# some additional datasets when E3SM updating progressively, if needed
#cd ./atm/cam/chem/trop_mozart_aero/aero
#wget --no-check-certificate https://web.lcrc.anl.gov/public/e3sm/inputdata/atm/cam/chem/trop_mozart_aero/aero/aerosoldep_rcp4.5_monthly_1849-2104_1.9x2.5_c100402.nc
#cd ${cesm_data_dir}
 

# =======================================================================================

# =======================================================================================
# done
echo "*** DONE ***"
# =======================================================================================