# Dockerized version of the ELM models on GPU, with nvhpc 

<br>
This ELM docker image is built based on NVIDIA nvhpc23.5. It also includes:

- all needed software packages for ELM

- E3SM codes from https://github.com/fmyuan/E3SM.git, branch: peterdschwartz/lnd/hires-io, which is a copy of https://github.com/peterdschwartz/lnd/hires-io.git but with neccessay edits for docker

- OLMT from https://github.com/dmricciuto/OLMT.git, branch: Arctic-userpft

- point mode ELM input data, from https://github.com/fmyuan/pt-e3sm-inputdata.git. Specifically, it includes 42_FLUXNETSITES data for testing.

- SPELL:  Software-tools for Porting ELM with openacc in a function unit test framework (https://github.com/peterdschwartz/SPEL_OpenACC.git)


<br>

## docker pull

The specific docker image is on dockerhub.com, i.e. `docker.io/yuanfornl/elm_docker2023:nvhpc`

So the command is:
```
docker pull yuanfornl/elm_docker2023:nvhpc
```

## docker run





