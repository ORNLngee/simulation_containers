#!/bin/sh -v

# usage: copy this script to where petsc cloned or source directory, and run it there.

unset PETSC_DIR
unset PETSC_ARCH

PETSC_SOURCE_DIR=${PWD}
INSTALL_DIR=/usr/local/tpls/petsc

# for aarch64 or amd64, apt-get install packages into different named directories
INCBLASLAPACK=$(ls -d /usr/include/*-linux-gnu)
echo $INCBLASLAPACK
LIBBLAS=$(ls /usr/lib/*-linux-gnu/libblas.a)
echo $LIBBLAS
LIBLAPACK=$(ls /usr/lib/*-linux-gnu/liblapack.a)
echo $LIBLAPACK

## so run this shell script under petsc source direcotry
cd ./

./configure \
           --prefix=${INSTALL_DIR} \
           --with-clean=1 --with-c2html=0 --with-x=0 \
           --with-ssl=0 --with-debugging=0 --with-valgrind=0 \
           --with-shared-libraries=1 --with-debugging=0 --with-precision=double \
           --with-memalign=32 --with-64-bit-indices=0 \
           --with-fortran-bindings=1 \
           --with-blaslapack-include=${INCBLASLAPACK} \
           --with-blas-lib=${LIBBLAS} \
           --with-lapack-lib=${LIBLAPACK} \
           --with-cmake-exec=/usr/bin/cmake \
           --with-hdf5-dir=${HDF5_DIR} --with-hdf5-fortran-bindings=1 \
           --with-system-zlib \
           --download-sowing=yes \
           --download-metis=yes \
           --download-parmetis=yes \
           --download-scalapack=yes \
           --download-superlu=yes \
           --download-supperlu-dist=yes \
           --download-hypre=yes \
           MPI-DIR=/usr/local/openmpi \
           PETSC_DIR=${PETSC_SOURCE_DIR} \
           PETSC_ARCH=arch-linux-c-noopt \
           COPTFLAGS=" -fPIC -O0" \
           FCOPTFLAGS="-fPIC -O0" \
           CXXOPTFLAGS=" -fPIC -O0" \
           FOPTFLAGS=" -fPIC -O0"

make PETSC_DIR=${PETSC_SOURCE_DIR} PETSC_ARCH=arch-linux-c-noopt all
make PETSC_DIR=${PETSC_SOURCE_DIR} PETSC_ARCH=arch-linux-c-noopt install
#make PETSC_DIR=${INSTALL_DIR} PETSC_ARCH="" check

