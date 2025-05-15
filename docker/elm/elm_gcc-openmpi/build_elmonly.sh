## Build example case as a test  --- only used with initial codes build testing

E3SM_ROOT=$1 
#/Users/f9y/mygithub/E3SM_REPOS/E3SM_ORNL_IM
E3SM_MACH=$2

OUTPUT_DIR=${PWD}

cd ${E3SM_ROOT} \
    && export CASE_NAME=${OUTPUT_DIR}/f19_g16.IGSWELMBGC \
    && cd ./cime/scripts \
    && ./create_newcase --case ${CASE_NAME} --res f19_g16 --compset IGSWELMBGC --mach ${E3SM_MACH} --compiler gnu \
    && cd ${CASE_NAME} \
    && ./xmlchange DATM_CLMNCEP_YR_END=1995 \
    && ./xmlchange PIO_TYPENAME=netcdf \
    && ./xmlchange RUNDIR=${PWD}/run \
    && ./xmlchange EXEROOT=${PWD}/bld \
    && ./xmlchange NTASKS=1 \
    && ./xmlchange DIN_LOC_ROOT=$PWD \
    && cd ${CASE_NAME} \
    && ./case.setup \
    && ./case.build

echo "*** ELM test build completed successfully ***"
cd ${OUTPUT_DIR} \
    && rm -rf ./f19_g16.IGSWELMBGC

