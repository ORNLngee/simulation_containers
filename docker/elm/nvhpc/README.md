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

## (Optional) docker volumes
Make a docker space for model outputs. Look this step is OPTIONAL, but it's better for data organization, and when quit docker, it won't be lost.
```
docker volume create VolELM_runs
docker volume ls
(this command will show just created space within docker)
```

## docker run

The following command(s) will start an instance of pulled docker image, called `container`

### Accessing docker and run ELM like in a linux system
```
docker run -t -i --hostname=docker --user=modeluser -v VolELM_runs:/output/ yuanfornl/elm_docker2023:nvhpc
```

THEN, you will access the docker. You will see the following:

- /inputdata/
- /E3SM/
- /tools/OLMT/
- /tools/SPEL_OpenACC/
- /output/
- /scripts/

   **Under /scripts/**, there are 3 bash scripts, for downloading input data, run a point example, and run a multiple point example, i.e., 42_FLUXNETSITES.


NOTE: if open another linux terminal in your machine, and run the following command,
```
docker container ls
```

It will show current running container, with ID, IMAGE, STATUS, etc. info. That ID is very important for operative work with docker.


### run ELM docker commands
* Run ELM by implementing a bash script
```
docker run -t -i --hostname=docker --user=modeluser -v VolELM_runs:/output/ yuanfornl/elm_docker2023:nvhpc /bin/sh -c 'cd /scripts/ && bash OLMT_docker_example.sh'
```
This script will run OLMT for ELM to simulate at an exampled NGEE-Arctic site.

* Run ELM for 42_FLUXNETSITES
  
```
docker run -t -i --hostname=docker --user=modeluser -v VolELM_runs:/output/ yuanfornl/elm_docker2023:nvhpc /bin/sh -c 'cd /scripts/ && bash OLMT_docker_42fluxnetsites_example.sh -adsy 20 -fsy 0 -trsy 0'
```
NOTE: `  -adsy 20 -fsy 0 -trsy 0 ` options mean that run accelerated spinup 20 years, no final spinup and no transient run.


