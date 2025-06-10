# Dockerized versions of the ELM models, with or without coupling with alquimia-PFLOTRAN, or ATS. 
<br>
UPDATED: 2025-06-10, developed by the teams in ORNL/BNL/LANL, and maintained by F-M Yuan.

<br>
Docker hub: https://hub.docker.com/u/yuanfornl

NOTE: 1) this forked repository is for purpose of improvements in applications relevant to NGEE-Arctic Project, sponsored by DOE-BER.
      2) It's been in progress of development. 

## Branch 'master'
<br>
This branch now is a new version, totally based on quay.io/scipy-notebook images as the baseOS. For purposes of ELM model + two high-resoultion models, we provide:

### *ELM-PFLOTRAN models*

### *ELM-ATS models*

<br>

## Branch 'maint-v1'
<br>
This branch is for maintaining the original version of NGEE Arctic ModEx Workshop. Essentially it's a totally linuxOS+compbilers based docker container. During past few years, two major compliers are tested: gnu/openmpi, and nvhpc compilers.
There are yearly maintained images:

### *v2025* 
yuanfornl/elm_docker2025:latest

### *v2021* 
Note: this is copy of the original, which may be still used by someone but requiring maintenance with time (due to hardware/software reasons).

[yuanfornl/elm-builds:elm_v2-for-ngee_multiarch](https://hub.docker.com/repository/docker/yuanfornl/elm-builds/tags)
```
docker pull yuanfornl/elm-builds:elm_v2-for-ngee_multiarch
```

### *v2022* 
yuanfornl/elm_docker2022:latest

a version based on NVDIA compilers system was developed for using NVDIA's GPU.
yuanfornl/elm_docker2022:nvhpc

### *v2023* 
yuanfornl/elm_docker2023:nvhpc

### *v2024*
yuanfornl/elm_docker2024:nvhpc

<br>
<br>
