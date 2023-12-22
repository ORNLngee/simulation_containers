# -------------------------------------------------------------------------------------------
#
# Ubuntu/gcc baseOS docker container for building ELM/PFLOTRAN
# AMD64
#
# -------------------------------------------------------------------------------------------
#
FROM gcc:9.5.0
# (Debian GNU/Linux OS distro)

LABEL maintainer.name="F.-M. Yuan" \
      maintainer.email="yuanf@ornl.gov" \
      author.name="Fengming Yuan" \
      author.email="yuanf@ornl.gov" \
      description="Nvidia HPC xSDK based image loaded with necessary dependencies for building ELM images"

# Update the system and install initial dependencies
#RUN apt update -y \
#    && apt install -y \
#    apt-utils \
#    apt-transport-https \
#    csh \
#    ftp \
#    gdb \
#    locales \
#    gsl-bin \
#    libgsl-dev \

#    libgmp3-dev \
#    libcurl4-openssl-dev \
#    libncurses5-dev \
#    libssl-dev \
#    libxml2 \
#    libxml2-dev \
#    libxml-libxml-perl \
#    libxml2-utils \
#    libudunits2-0 \
#    libudunits2-dev \
#    libsqlite3-dev \
#    nco \
#    openmpi-bin \
#    openssl \
#    python3 \
#    python3-dev \
#    python3-pip \
#    zip \
#    udunits-bin \
#    unzip \
#    && rm -rf /var/lib/apt/lists/* \
#    && apt-get clean all

# Add symlink 'python' to python3
#RUN ln -sf /usr/bin/python3 /usr/bin/python

## Install program to configure locales
#RUN echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen \
#    && locale-gen
## Set default locale for the environment
#ENV LANG en_US.UTF-8
#ENV LANGUAGE en_US.UTF-8

## check locales
#RUN locale -a

# Set a few variables that can be used to control the docker build
#ARG ZLIB_VERSION=1.2.13
#ARG EXPAT_VERSION=2.4.7
#ARG HDF5_VERSION_MAJOR=1.12
#ARG HDF5_VERSION_STRING=1.12.2
#ARG NETCDF_C_VERSION=4.9.2
#ARG NETCDF_FORTRAN_VERSION=4.6.1
#ARG NETCDF_CXX_VERSION=4.3.1

# ZLIB building with nvhpc, otherwise using that from ubuntu
#ARG ZLIB_DIR=/usr/local/zlib
#RUN cd / \
#    && wget https://www.zlib.net/zlib-$ZLIB_VERSION.tar.gz \
#    && tar -xzf zlib-$ZLIB_VERSION.tar.gz \
#    && cd zlib-$ZLIB_VERSION \
#    && CFLAGS=-fPIC ./configure --64 --prefix=$ZLIB_DIR \
#    && make all && make install \
#    && cd / \
#    && rm -rf zlib-$ZLIB_VERSION \
#    && rm zlib-$ZLIB_VERSION.tar.gz
    
#ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$ZLIB_DIR/lib

## Compile Expat XML parser
#RUN cd / \
#    && wget https://github.com/libexpat/libexpat/releases/download/R_2_4_7/expat-$EXPAT_VERSION.tar.bz2 \
#    && tar -xvjf expat-$EXPAT_VERSION.tar.bz2 \
#    && cd expat-$EXPAT_VERSION \
#    && ./configure \
#    && make \
#    && make install \
#    && cd / \
#    && rm -r expat-$EXPAT_VERSION \
#    && rm expat-$EXPAT_VERSION.tar.bz2

#ENV $LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib

## Install python libraries
#RUN pip3 install wheel
#RUN pip3 install numpy
#RUN pip3 install scipy
#RUN pip3 install cftime
#RUN pip3 install netCDF4
#RUN pip3 install h5py
#RUN pip3 install configparser
#RUN pip3 install pyproj
#RUN pip3 install rasterio
#RUN pip3 install Dask
#RUN CFLAGS=-noswitcherror pip3 install mpi4py


## the following step is to run this image as a container, access it and build HDF5
## and, then docker commit it and push into docker hub.

## HDF5 - https://support.hdfgroup.org/ftp/HDF5/releases/
## NOTE: the following cmake building works inside contanier but not with docker build command.
##      It's strange - saying that cannot find libopen-rte.lib or something relevant to openmpi inside Nvidia HPC xSDK
##      So, we ignore it currently, and build it inside running baseos image container, and then continuely the whole images progressively:
##         STEP 1: docker build -t yuanfornl/elm_baseos_nvhpc:23.5 --platform linux/amd64 -f ./Dockerfile .
##         STEP 2: docker run -t -i yuanfornl/elm_baseos_nvhpc:23.5
##         STEP 3: (now after STEP 2, we're inside docker container) build HDF5 using following commands.
##                   prior to this, set a few ENVs
##                   export HDF5_VERSION_MAJOR = 1.12
##                   export HDF5_VERSION_STRING = 1.12.2
##                   (THEN, copy & paste the whole line commands after RUN)
##         STEP 4: (start another terminal, commit and upload newly-built image `yuanfornl/elm_baseos_nvhpc:23.5`)
##                 docker container ls
##                     (it will show CONTAINER ID xxxxxxx)
##                 docker commit xxxxxx yuanfornl/elm_baseos_nvhpc:23.5
##                 docker push yuanfornl/elm_baseos_nvhpc:23.5
##         STEP 5: (after successfully push image up to docker.io)
##                 docker build -t yuanfornl/elm_baseos_nvhpc:latest --platform linux/amd64 -f ./Dockerfile_ext .

#RUN cd / \
#    && mkdir -p /usr/local/hdf5 \
#    && export HDF5_DIR=/usr/local/hdf5 \
#    && wget https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-$HDF5_VERSION_MAJOR/hdf5-$HDF5_VERSION_STRING/src/hdf5-$HDF5_VERSION_STRING.tar.gz \
#    && tar -zxvf hdf5-$HDF5_VERSION_STRING.tar.gz \
#    && cd hdf5-$HDF5_VERSION_STRING \
#    && mkdir -p build \
#    && cd build \
#    && CC=mpicc FC=mpif90 CXX=mpicxx cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release -DHDF5_ENABLE_PARALLEL=ON -DHDF5_BUILD_FORTRAN=ON -DHDF5_BUILD_CPP_LIB=OFF -DHDF5_ENABLE_THREADSAFE=OFF -DHDF5_ENABLE_Z_LIB_SUPPORT=ON -DZLIB_LIBRARY=/usr/local/zlib/lib/libz.so -DCMAKE_INSTALL_PREFIX=$HDF5_DIR .. \
#    && make -j2 all && make install \
#    && cd / \
#    && rm -rf hdf5-$HDF5_VERSION_STRING \
#    && rm hdf5-$HDF5_VERSION_STRING.tar.gz

##

#ARG HDF5_DIR=/usr/local/hdf5
#ENV PATH=$PATH:$HDF5_DIR/bin
#ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HDF5_DIR/lib


### EOF
