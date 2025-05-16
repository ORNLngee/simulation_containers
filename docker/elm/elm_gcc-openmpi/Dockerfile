
# ----------------------------------------------------------------------
# Debian container - gcc-11.4/openmpi-4.1.2
# E3SM/ELM land model docker container
# 
# Authors: Shawn Serbin@BNL, and others from ORNL (e.g. F-M. Yuan), LANL (e.g. Rich Fiolla)
# maintained by F.-M. Yuan@ORNL
#
# This is folked from author's github repository for purpose of improvement only
# copyright belongs to author(s)
#
# ----------------------------------------------------------------------

FROM yuanfornl/elm_baseos:gcc1140ompi412_multiarch
LABEL maintainer.name="Fengming Yuan" \
      maintainer.email="yuanf@ornl.gov" \
      author.name="Shawn P. Serbin" \
      author.email="sserbin@bnl.gov" \
      description="ELM host land model" \
      version.elm="elm master" \
      version.baseos="gcc-11.4/openmpi-4.1.2"

# python packages often used by ELM and data analysis
RUN cd / \
    && pip3 install --upgrade pip \
    && pip3 install matplotlib \
    && pip3 install pyproj \
    && pip3 install dask
    
# where to get the ELM source code
ENV REPOSITORY_URL=https://github.com/ORNLngee/simulation_containers
ENV TOOLS_REPOSITORY_URL=https://github.com/ORNLngee/ngeeA_elm_simulation_tools
ENV USER=modeluser

# Add new group, user, and user directory with user permissions
RUN groupadd -r dockerusers \
    && useradd -ms /bin/bash $USER -u 1001 -g dockerusers \
    && chown $USER:dockerusers /home/$USER

## create data mount point in container
## could change this to /mnt or something more generic in machines files
RUN cd / \
    && mkdir -p inputdata \
    && mkdir -p example_inputs \
    && mkdir -p output \
    && mkdir -p scripts \
    && mkdir -p tools \
    && mkdir -p tools/cprnc \
    && mkdir -p baselines \
    && mkdir -p .cime \
    && mkdir -p /home/$USER/.cime \
    && chown $USER inputdata \
    && chown $USER example_inputs \
    && chown $USER output \
    && chown $USER scripts \
    && chown $USER tools \
    && chown $USER tools/cprnc \
    && chown $USER baselines \
    && chown $USER .cime \
    && chown $USER /home/$USER/.cime \
    && cd /

## Checkout ELM model
##  note: there are 2 perl commands, which edit 'git@github.com:' to 'https://github.com/'

RUN cd / \
    && git -c http.sslVerify=false clone -b master --single-branch --depth 1 https://github.com/ORNLngee/E3SM_ORNL_IM.git /E3SM \
    && cd /E3SM \
    && perl -pi -e 's/com:/com\//g' ./.gitmodules \
    && perl -pi -e 's/git@/https:\/\//g' ./.gitmodules \
    && git submodule init \
    && git submodule update -f --recursive

RUN cd /.cime \
    && wget $REPOSITORY_URL/raw/maint-v1/docker/elm/cime_config/config \
    && wget $REPOSITORY_URL/raw/maint-v1/docker/elm/cime_config/config_compilers.xml \
    && wget $REPOSITORY_URL/raw/maint-v1/docker/elm/cime_config/config_machines.xml \
    && wget $REPOSITORY_URL/raw/maint-v1/docker/elm/cime_config/gnu_docker.cmake \
    && cd /home/$USER/.cime \
    && wget $REPOSITORY_URL/raw/maint-v1/docker/elm/cime_config/config \
    && wget $REPOSITORY_URL/raw/maint-v1/docker/elm/cime_config/config_compilers.xml \
    && wget $REPOSITORY_URL/raw/maint-v1/docker/elm/cime_config/config_machines.xml \
    && wget $REPOSITORY_URL/raw/maint-v1/docker/elm/cime_config/gnu_docker.cmake \
    && cd /

# Provide a symlink between ncap and ncap2 for OLMT 
RUN ln -s /usr/bin/ncap2 /usr/bin/ncap

# Switch to using modeluser for test build (so it can find the ~/.cime docker machine configuration files)
RUN cd /E3SM \
    && chown $USER:dockerusers /E3SM \
    && chmod -R 777 /E3SM \
    && export USER=${USER}

# Set user
USER ${USER}

## ------------------------------------------------------------------------------
## Build example case as a test  --- only used with initial Docker build testing
RUN cd /E3SM/cime/scripts \
    && export CASE_NAME=/output/f19_g16.IGSWELMBGC \
    && cd /E3SM/cime/scripts \
    && ./create_newcase --case ${CASE_NAME} --res f19_g16 --compset IGSWELMBGC --mach docker --compiler gnu \
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

RUN echo "*** ELM test build completed successfully ***"

## Remove test build
RUN cd / \
    && rm -rf /output/f19_g16.IGSWELMBGC
## ------------------------------------------------------------------------------

## Install OLMT tool into the container to use with site or ensemble simulations
# This uses a stable release of the Arctic-userpft branch of OLMT
RUN cd /tools \
    && git -c http.sslVerify=false clone -b Arctic-userpft --single-branch --depth 1 https://github.com/dmricciuto/OLMT.git \
    && chown $USER:dockerusers -R /tools/OLMT \
    && chmod -R 777 /tools/OLMT

## Copy a few scripts into /scripts to make availible to users
#    (1) downloading pt-e3sm-inputdata
RUN cd /scripts \
    && wget $TOOLS_REPOSITORY_URL/raw/master/met_scripts/download_elm_singlesite_forcing_data.sh \
    && chown $USER:dockerusers download_elm_singlesite_forcing_data.sh \
    && chmod +x download_elm_singlesite_forcing_data.sh

#    (2) an example OLMT script to setup/configure/build/run docker ELM
RUN cd /scripts \
    && wget $TOOLS_REPOSITORY_URL/raw/master/olmt_scripts/example_site_fullrun_userdata_docker.sh \
    && mv example_site_fullrun_userdata_docker.sh OLMT_docker_example.sh \
    && chown $USER:dockerusers OLMT_docker_example.sh \
    && chmod +x OLMT_docker_example.sh

#    (3) testing docker ELM by 42 fluxnet sites data
RUN cd /scripts \
    && wget $TOOLS_REPOSITORY_URL/raw/master/elm_scripts/test_docker_42fluxnetsites_example.sh \
    && chown $USER:dockerusers test_docker_42fluxnetsites_example.sh \
    && chmod +x test_docker_42fluxnetsites_example.sh \
    && cd /

USER ${USER}
RUN export USER=${USER} \
    && git config --global user.email "modeluser@docker.org" \
    && git config --global user.name "modeluser@docker.org"
    
## END
