#!/bin/sh

# First download met fording data. should add a user selectable flag here to skip
echo "***** Starting download of met forcing data *****"
sleep 1
cd $HOME/tools/scripts
cwd=$(pwd)
sh download_elm_singlesite_forcing_data.sh
sleep 5

cd $HOME
cwd=$(pwd)

cd $HOME/tools/OLMT

if python3 ./site_fullrun.py \
      --site AK-K64G --sitegroup NGEEArctic --caseidprefix OLMT \
      --nyears_ad_spinup 200 --nyears_final_spinup 600 --tstep 1 \
      --machine docker --compiler gnu --mpilib openmpi \
      --cpl_bypass --gswp3 \
      --model_root $HOME/models/E3SM \
      --caseroot $HOME/output \
      --ccsm_input $HOME/inputdata \
      --runroot $HOME/output \
      --spinup_vars \
      --nopointdata \
      --metdir $HOME/inputdata/atm/datm7/atm_forcing.datm7.GSWP3.0.5d.v2.c180716_kougarok-Grid/cpl_bypass_full \
      --domainfile $HOME/inputdata/share/domains/domain.clm/domain.lnd.1x1pt_kougarok-GRID_navy.nc \
      --surffile $HOME/inputdata/lnd/clm2/surfdata_map/surfdata_1x1pt_kougarok-GRID_simyr1850_c360x720_171002.nc \
      --landusefile $HOME/inputdata/lnd/clm2/surfdata_map/landuse.timeseries_1x1pt_kougarok-GRID_simyr1850-2015_c180423.nc \
      & sleep 10

then
  wait

  echo "DONE docker ELM runs !"

else
  exit &?
fi

cd ${cwd}
sleep 2

#### Postprocess
### Collapse transient simulation output into a single netCDF file
echo " "
echo " "
echo " "
cd $HOME/output/cime_run_dirs/OLMT_AK-K64G_ICB20TRCNPRDCTCBC/run
echo "**** Concatenating netCDF output - Hang tight this can take awhile ****"
ncrcat --ovr *.h0.*.nc ELM_output.nc
chmod 777 ELM_output.nc
echo "**** Concatenating netCDF output: DONE ****"
sleep 1


# for grid-cell gswp3 v2 (1901-2014)
#      --cpl_bypass --gswp3 \

# for daymet corrected gswp3 v1 ( 1980 - 2010, CONUS only)
#      --cpl_bypass --gswp3 --daymet \

# for daymet4 corrected gswp3 v2 ( 1980 - 2014, Northern America only, 1km resolution, unstructured-grid)
#      --cpl_bypass --gswp3 --daymet4 \

# user-provided cpl_bypass data
#      --metdir $HOME/inputdata/atm/datm7/atm_forcing.datm7.GSWP3_daymet.1x1pt_kougarok-NGEE/cpl_bypass_full \

# If for ELM after June-2021, turning off 'do_budgets'
#     --no_dobudgets \