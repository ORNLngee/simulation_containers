
# Generic ATS build script that invokes Amanzi's bootstrap.sh 
# with options configured for an ATS build

# amanzi-ats Source directories
export AMANZI_SRC_DIR=${PWD}
export ATS_SRC_DIR=$AMANZI_SRC_DIR/src/physics/ats

# ENVs for amanzi-TPLs
export ATS_BASE=$1
export TPLS_VERSION=$2
export AMANZI_TPLS_DIR=$3
export TPLS_BUILD_TYPE=opt
if ![ -d ${AMANZI_TPLS_DIR} ]; then
   echo "NO amanzi-tpls found: ${AMANZO_TPLS_DIR}"
   exit
else
   echo "amanzi-tpls found: ${AMANZO_TPLS_DIR}"
fi

# ENVs for amanzi-ats
export ATS_VERSION=master
export ATS_BUILD_TYPE=opt
export AMANZI_TPLS_BUILD_DIR=$ATS_BASE/build/amanzi-tpls
export AMANZI_BUILD_DIR=$ATS_BASE/build/amanzi-ats
export ATS_BUILD_DIR=$AMANZI_BUILD_DIR

export AMANZI_DIR=$4
export ATS_DIR=${AMANZI_DIR}

# see INSTALL_ATS.md for more information

if [ ${ATS_BUILD_TYPE} == Debug ]
then
    dbg_option=--debug
elif [ ${ATS_BUILD_TYPE} == RelWithDebInfo ]
then
    dbg_option=--relwithdebinfo
else
    dbg_option=--opt
fi

echo "Running Amanzi Boostrap with:"
echo "  AMANZI_SRC_DIR: ${AMANZI_SRC_DIR}"
echo "  AMANZI_BUILD_DIR: ${AMANZI_BUILD_DIR}"
echo "  AMANZI_INSTALL_DIR: ${AMANZI_DIR}"
echo "  AMANZI_TPLS_BUILD_DIR: ${AMANZI_TPLS_BUILD_DIR}"
echo "  AMANZI_TPLS_DIR: ${AMANZI_TPLS_DIR}"
echo " with build type: ${ATS_BUILD_TYPE}"
echo ""


echo "unset $PETSC_DIR: "
unset PETSC_DIR
unset PETSC_ARCH
echo "$PETSC_DIR "
echo "$PETSC_ARCH "

${AMANZI_SRC_DIR}/bootstrap.sh \
   ${dbg_option} \
   --with-mpi=${MPI_DIR} --tools-mpi=${MPINAME} \
   --enable-shared \
   --enable-clm \
   --disable-structured  --enable-unstructured \
   --enable-mesh_mstk --disable-mesh_moab \
   --enable-hypre \
   --enable-silo \
   --enable-petsc \
   --disable-amanzi_physics \
   --enable-ats_physics \
   --ats_dev \
   --enable-geochemistry --enable-alquimia --enable-pflotran --enable-crunchtope \
   --enable-elm_ats_api \
   --enable-reg_tests \
   --enable-test_suites \
   --amanzi-install-prefix=${AMANZI_DIR} \
   --amanzi-build-dir=${AMANZI_BUILD_DIR} \
   --tpl-config-file=${AMANZI_TPLS_DIR}/share/cmake/amanzi-tpl-config.cmake \
   --tools-download-dir=${ATS_BASE}/Downloads/tools \
   --tools-build-dir=${AMANZI_TPLS_BUILD_DIR}/tools \
   --tools-install-prefix=${AMANZI_TPLS_DIR}/tools \
   --with-cmake=`which cmake` \
   --with-ctest=`which ctest` \
   --with-python=`which python3` \
   --branch_ats=${ATS_VERSION} \
   --parallel=6
   
# if alreeady have MPI on your system
#   --with-mpi=${MPI_ROOT} --tools-mpi=mpich \

# if building MPI by TPLs (default: openmpi)
#   --tools-mpi=openmpi \

# If TPLs have NOT already been built, OR want to redo it
# through that long process again, replace
#   --tpl-config-file=${AMANZI_TPLS_DIR}/share/cmake/amanzi-tpl-config.cmake \
# with
#   --tpl-install-prefix=${AMANZI_TPLS_DIR} \
#   --tpl-build-dir=${AMANZI_TPLS_BUILD_DIR} \
#   --tpl-download-dir=${ATS_BASE}/Downloads/amanzi-tpls \

# new/updated install directories
echo "export AMANZI_SRC_DIR=${AMANZI_SRC_DIR}">>$HOME/.bashrc
echo "export AMANZI_DIR=${AMANZI_DIR}">>$HOME/.bashrc

echo "export PATH=${AMANZI_DIR}/bin:\$PATH">>$HOME/.bashrc
echo "export LD_LIBRARY_PATH=${AMANZI_DIR}/lib:\$LD_LIBRARY_PATH">>$HOME/.bashrc

