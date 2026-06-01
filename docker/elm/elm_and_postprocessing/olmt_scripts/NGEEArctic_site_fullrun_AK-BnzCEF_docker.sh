#!/bin/sh

sleep 5

cd $HOME
cwd=$(pwd)

cd $HOME/tools/OLMT

if python3 ./site_fullrun.py \
      --site AK-BCEF --sitegroup NGEEArctic --caseidprefix OLMT \
      --nyears_ad_spinup 200 --nyears_final_spinup 600 --nyears_transient 174 --tstep 1 \
      --machine docker --compiler gnu --mpilib openmpi \
      --cpl_bypass --trendy25 \
      --model_root $HOME/models/E3SM \
      --caseroot $HOME/output/cime_case_dirs \
      --ccsm_input $HOME/inputdata \
      --runroot $HOME/output/cime_run_dirs \
      --spinup_vars \
      --nopointdata \
      --metdir $HOME/inputdata/atm/datm7/atm_forcing.CRUJRA_trendy_2025_NGEE-Grid/BCEF/cpl_bypass_full \
      --domainfile $HOME/inputdata/share/domains/domain.clm/domain.lnd.r0125_IcoswISC30E3r5.250918_BCEF.nc \
      --surffile $HOME/inputdata/lnd/clm2/surfdata_map/surfdata_0.125x0.125_simyr1850_c250910_TOP_BCEF.nc \
      --nopftdyn \
      --np 4 \
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
cd $HOME/output/cime_run_dirs/OLMT_AK-BCEF_ICB20TRCNPRDCTCBC/run
echo "**** Concatenating netCDF output - Hang tight this can take awhile ****"
ncrcat --ovr *.h0.*.nc ELM_output.nc
chmod 777 ELM_output.nc
echo "**** Concatenating netCDF output: DONE ****"
sleep 1

