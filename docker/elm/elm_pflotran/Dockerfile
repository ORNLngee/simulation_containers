
# ----------------------------------------------------------------------
# Debian container - gcc9.4
# E3SM/ELM land model docker container
# AMD64 version
#
# This is folked from author's github repository for purpose of improvement only
# copyright belongs to author(s)
#
# ----------------------------------------------------------------------

FROM fasstsimulation/baseos:gcc940ompi412-latest
LABEL maintainer.name="Benjamin N. Sulman" \
      maintainer.email="sulmanbn@ornl.gov" \
      author.name="Benjamin N. Sulman" \
      author.email="sulmanbn@ornl.gov" \
      description="ELM-PFLOTRAN model" \
      version.hlm="elm_pflotran" \
      version.baseos="gcc9.4"

# python packages often used by ELM and data analysis
RUN cd / \
    && pip3 install --upgrade pip \
    && pip3 install h5py \
    && pip3 install mpi4py \
    && pip3 install matplotlib \
    && pip3 install pyproj \
    && pip3 install dask
    
# where to get the ELM source code
#ENV REPOSITORY_URL=https://github.com/FASSt-simulation/simulation_containers
ENV REPOSITORY_URL=https://github.com/fmyuan/elm_containers
ENV REPOSITORY_RAW_URL=https://raw.githubusercontent.com/fmyuan/elm_containers
ENV TOOLS_REPOSITORY_RAW_URL=https://raw.githubusercontent.com/FASSt-simulation/fasst_simulation_tools
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
    && mkdir -p home/$USER/.cime \
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


# Install PETSC
RUN cd / \
    && git clone -b v3.18.3 https://gitlab.com/petsc/petsc.git petsc \
    && cd petsc \
    && ./configure \
            --with-mpi-dir=/usr/local \
            --with-hdf5-dir=/usr/local/hdf5 \
            --download-fblaslapack=no \
            --with-blas-lapack-dir=/usr/lib/x86_64-linux-gnu \
            --with-hdf5-fortran-bindings \
    && make PETSC_DIR=/petsc PETSC_ARCH=arch-linux-c-debug all

ENV PETSC_DIR=/petsc
ENV PETSC_ARCH=arch-linux-c-debug

# Install PFLOTRAN
RUN cd / \
    && git clone -b pflotran-elm-interface https://github.com/bsulman/pflotran-elm-interface.git \
    && cd pflotran-elm-interface/src/pflotran \
    && make pflotran pflotran_rxn

ENV PFLOTRAN_DIR=/pflotran-elm-interface/src/pflotran
ENV OPENMPI_DIR=/usr/local

# Install alquimia and related python scripts
RUN    pip3 install networkx \
    && pip3 install xarray \
    && pip3 install cffi

RUN cd / && git clone -b alquimia_compile_fix --recursive https://github.com/bsulman/REDOX-PFLOTRAN.git \
    && mkdir REDOX-PFLOTRAN/alquimia/build \
    && cd REDOX-PFLOTRAN/alquimia/build \
    && cmake .. \
        -DCMAKE_INSTALL_PREFIX=. \
        -DCMAKE_C_COMPILER=$OPENMPI_DIR/bin/mpicc \
        -DCMAKE_CXX_COMPILER=$OPENMPI_DIR/bin/mpicxx \
        -DCMAKE_Fortran_COMPILER=$OPENMPI_DIR/bin/mpif90 \
        -DCMAKE_BUILD_TYPE=Debug \
        -DXSDK_WITH_PFLOTRAN=ON \
        -DTPL_PFLOTRAN_LIBRARIES=$PFLOTRAN_DIR/libpflotranchem.a \
        -DTPL_PFLOTRAN_INCLUDE_DIRS=$PFLOTRAN_DIR \
        -DCMAKE_Fortran_FLAGS="-DPFLOTRAN_SOMDEC" \
    && make install \
    && cd ../.. \
    && python3 make_alquimia_python_interface.py \
    && python3 network_for_ELM.py \
    && chmod -R 777 /REDOX-PFLOTRAN


## Checkout ELM model
# Submodule update command is replacing ssh with https so authentication to github isn't required
RUN cd / \
    && git -c http.sslVerify=false -c url."https://github.com/".insteadOf="git@github.com:" clone -b bsulman/lnd/alquimia_salinity --single-branch --depth 1 --recurse-submodules --shallow-submodules https://github.com/bsulman/E3SM.git \
    # && cd /E3SM \
    # && git -c http.sslVerify=false -c url."https://github.com/".insteadOf="git@github.com:" submodule update --init --recursive \
    && chown $USER:dockerusers /E3SM \
    && chmod -R 777 /E3SM

RUN cd /E3SM \
    && cd /.cime \
    && wget $REPOSITORY_URL/raw/master/docker/elm/cime_config/config \
    && wget https://github.com/bsulman/elm_containers/raw/elm_pflotran/docker/elm/cime_config_alquimia/config_compilers.xml \
    && wget $REPOSITORY_URL/raw/master/docker/elm/cime_config/config_machines.xml \
    && wget https://github.com/bsulman/elm_containers/raw/elm_pflotran/docker/elm/cime_config_alquimia/gnu_docker.cmake \
    && cd /home/$USER/.cime \
    && wget $REPOSITORY_URL/raw/master/docker/elm/cime_config/config \
    && wget https://github.com/bsulman/elm_containers/raw/elm_pflotran/docker/elm/cime_config_alquimia/config_compilers.xml \
    && wget $REPOSITORY_URL/raw/master/docker/elm/cime_config/config_machines.xml \
    && wget https://github.com/bsulman/elm_containers/raw/elm_pflotran/docker/elm/cime_config_alquimia/gnu_docker.cmake \
    && cd /


# Provide a symlink between ncap and ncap2 for OLMT 
# Switch to using modeluser for test build (so it can find the ~/.cime docker machine configuration files)

RUN ln -sf /usr/bin/python3 /usr/bin/python && ln -s /usr/bin/ncap2 /usr/bin/ncap

# Set user
USER ${USER}

## ------------------------------------------------------------------------------
## Build example case as a test  --- only used with initial Docker build testing
#RUN cd /E3SM/cime/scripts \
#    && export CASE_NAME=/output/f19_g16.IGSWELMBGC \
#    && cd /E3SM/cime/scripts \
#    && ./create_newcase --case ${CASE_NAME} --res f19_g16 --compset IGSWELMBGC --mach docker --compiler gnu \
#    && cd ${CASE_NAME} \
#    && ./xmlchange DATM_CLMNCEP_YR_END=1995 \
#    && ./xmlchange PIO_TYPENAME=netcdf \
#    && ./xmlchange RUNDIR=${PWD}/run \
#    && ./xmlchange EXEROOT=${PWD}/bld \
#    && ./xmlchange NTASKS=1 \
#    && ./xmlchange DIN_LOC_ROOT=$PWD \
#    && cd ${CASE_NAME} \
#    && ./case.setup \
#    && ./case.build

#RUN echo "*** ELM test build completed successfully ***"

## Remove test build
#RUN cd / \
#    && rm -rf /output/f19_g16.IGSWELMBGC
## ------------------------------------------------------------------------------

## Install OLMT tool into the container to use with site or ensemble simulations
# This uses a stable release of the Arctic-userpft branch of OLMT
RUN cd /tools \
    && git -c http.sslVerify=false clone -b bsulman/coastal_main_rebased --single-branch --depth 1 https://github.com/dmricciuto/OLMT.git \
    && chown $USER:dockerusers -R /tools/OLMT \
    && chmod -R 777 /tools/OLMT

# Copy scripts into /scripts to make availible to users
RUN cd /scripts \
    && wget $TOOLS_REPOSITORY_RAW_URL/main/met_scripts/ngeearctic/download_elm_singlesite_forcing_data.sh \
    && wget $TOOLS_REPOSITORY_RAW_URL/main/elm_scripts/ngeearctic_elm_scripts/olmt_scripts/ngeearctic_site_fullrun_userdata_docker.sh \
    && mv ngeearctic_site_fullrun_userdata_docker.sh OLMT_docker_example.sh \
    && chown $USER:dockerusers download_elm_singlesite_forcing_data.sh \
    && chmod +x download_elm_singlesite_forcing_data.sh \
    && chown $USER:dockerusers OLMT_docker_example.sh \
    && chmod +x OLMT_docker_example.sh

USER ${USER}
RUN export USER=${USER}
## END
