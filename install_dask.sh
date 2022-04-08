#!/bin/bash
set -ex

worker_nodes=${1}
IFS=',' read -r -a workers <<< "$worker_nodes"

docker run --privileged -d --restart on-failure --network host -p 8787:8787  ghcr.io/dask/dask dask-scheduler --interface eno1d1  

for worker in ${workers[@]}
do 
	ssh $worker "docker run --privileged -d --restart on-failure --network host -p 8787:8787  ghcr.io/dask/dask dask-worker --interface eno1d1 tcp://10.10.1.1:8786" 
done

