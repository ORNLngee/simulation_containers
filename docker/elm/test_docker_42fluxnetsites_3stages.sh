#!/bin/bash

set -e

# ---------------------------------------------------------------------------------------------------------------------
# STAGE 1: 200-years accelerated spinup 

if \

CASEDIR="$HOME/output/cime_case_dirs/ELMcpu_42SITES_I1850CNRDCTCBC_ad_spinup"

rm -rf "${CASEDIR}"

$HOME/models/E3SM/cime/scripts/create_newcase --case "${CASEDIR}" --mach docker --compset I1850CNRDCTCBC --res ELM_USRDAT --mpilib openmpi --walltime 6:0:00 --handle-preexisting-dirs u --compiler gnu

cd "${CASEDIR}"

./xmlchange CIME_OUTPUT_ROOT=$HOME/output/cime_run_dirs

./xmlchange ELM_USRDAT_NAME=42_FLUXNETSITES

./xmlchange LND_DOMAIN_FILE=domain_42_FLUXNETSITES_simyr1850_c170912.nc

./xmlchange ATM_DOMAIN_FILE=domain_42_FLUXNETSITES_simyr1850_c170912.nc

./xmlchange DATM_MODE=CLM1PT

./xmlchange DATM_CLMNCEP_YR_START=1901

./xmlchange DATM_CLMNCEP_YR_END=1930

./xmlchange --append ELM_BLDNML_OPTS="-bgc_spinup on"

./xmlchange STOP_OPTION=nyears

./xmlchange STOP_N=200

./xmlchange NTASKS=$MAX_NPROC

./xmlchange NTHRDS=1

echo " 
 fsurdat='/home/jovyan/inputdata/lnd/clm2/surfdata_map/surfdata_42_FLUXNETSITES_simyr1850_c170912.nc' 
 hist_empty_htapes = .true.
 hist_fincl1 = 'TLAI', 'TOTSOMC', 'TSOI', 'H2OSOI'
">>user_nl_elm

echo "
 taxmode = 'cycle','extend','extend'
">>user_nl_datm

./case.setup --clean

./case.setup

./case.build --clean-all

./case.build

./case.submit


then
  wait

  echo "DONE docker ELM running case:  $CASEDIR !"

else
  exit &?

fi;


# ---------------------------------------------------------------------------------------------------------------------
# STAGE 2: 600-years (normal) spinup 

if \

CASEDIR="$HOME/output/cime_case_dirs/ELMcpu_42SITES_I1850CNPRDCTCBC"

rm -rf "${CASEDIR}"

$HOME/models/E3SM/cime/scripts/create_newcase --case "${CASEDIR}" --mach docker --compset I1850CNPRDCTCBC --res ELM_USRDAT --mpilib openmpi --walltime 6:0:00 --handle-preexisting-dirs u --compiler gnu

cd "${CASEDIR}"

./xmlchange CIME_OUTPUT_ROOT=$HOME/output/cime_run_dirs

./xmlchange ELM_USRDAT_NAME=42_FLUXNETSITES

./xmlchange LND_DOMAIN_FILE=domain_42_FLUXNETSITES_simyr1850_c170912.nc

./xmlchange ATM_DOMAIN_FILE=domain_42_FLUXNETSITES_simyr1850_c170912.nc

./xmlchange DATM_MODE=CLM1PT

./xmlchange DATM_CLMNCEP_YR_START=1901

./xmlchange DATM_CLMNCEP_YR_END=1930

./xmlchange STOP_OPTION=nyears

./xmlchange STOP_N=600

./xmlchange NTASKS=$MAX_NPROC

./xmlchange NTHRDS=1

echo " 
 fsurdat='/home/jovyan/inputdata/lnd/clm2/surfdata_map/surfdata_42_FLUXNETSITES_simyr1850_c170912.nc' 
 finidat='/home/jovyan/output/cime_run_dirs/ELMcpu_42SITES_I1850CNRDCTCBC_ad_spinup/run/ELMcpu_42SITES_I1850CNRDCTCBC_ad_spinup.elm.r.0201-01-01-00000.nc'
 hist_empty_htapes = .true.
 hist_fincl1 = 'TLAI', 'TOTSOMC', 'TSOI', 'H2OSOI'
">>user_nl_elm

echo "
 taxmode = 'cycle','extend','extend' 
">>user_nl_datm


./case.setup --clean

./case.setup

./case.build --clean-all

./case.build

./case.submit


; then
  wait

  echo "DONE docker ELM running case:  $CASEDIR !"

else
  exit &?

fi;


# ---------------------------------------------------------------------------------------------------------------------
# STAGE 3: 166-years transient run

if \

CASEDIR="$HOME/output/cime_case_dirs/ELMcpu_42SITES_I20TRCNPRDCTCBC"

rm -rf "${CASEDIR}"

$HOME/models/E3SM/cime/scripts/create_newcase --case "${CASEDIR}" --mach docker --compset I20TRCNPRDCTCBC --res ELM_USRDAT --mpilib openmpi --walltime 6:0:00 --handle-preexisting-dirs u --compiler gnu

cd "${CASEDIR}"

./xmlchange CIME_OUTPUT_ROOT=$HOME/output/cime_run_dirs

./xmlchange ELM_USRDAT_NAME=42_FLUXNETSITES

./xmlchange LND_DOMAIN_FILE=domain_42_FLUXNETSITES_simyr1850_c170912.nc

./xmlchange ATM_DOMAIN_FILE=domain_42_FLUXNETSITES_simyr1850_c170912.nc

./xmlchange DATM_MODE=CLM1PT

./xmlchange DATM_CLMNCEP_YR_START=1850

./xmlchange DATM_CLMNCEP_YR_END=2015

./xmlchange STOP_OPTION=nyears

./xmlchange STOP_N=166

./xmlchange REST_N=15

./xmlchange NTASKS=$MAX_NPROC

./xmlchange NTHRDS=1

echo " 
&clm_inparm
 fsurdat='/home/jovyan/inputdata/lnd/clm2/surfdata_map/surfdata_42_FLUXNETSITES_simyr1850_c170912.nc'
 flanduse_timeseries=''
 finidat='/home/jovyan/output/cime_run_dirs/ELMcpu_42SITES_I1850CNPRDCTCBC/run/ELMcpu_42SITES_I1850CNPRDCTCBC.elm.r.0601-01-01-00000.nc'
 hist_fincl2 = 'VCMAX25TOP','TLAI','GPP','NPP','NEE','AR','TOTVEGC','LEAFC','FROOTC','DEADSTEMC','LIVESTEMC','DEADCROOTC','LIVECROOTC'
 hist_dov2xy = .true., .false.
 hist_nhtfrq = 0, -24
">>user_nl_elm

echo "
 taxmode = 'cycle','extend','extend','extend' 
">>user_nl_datm


./case.setup --clean

./case.setup

./case.build --clean-all

./case.build

./case.submit

then
  wait

  echo "DONE docker ELM running case:  $CASEDIR !"

else
  exit &?

fi;
