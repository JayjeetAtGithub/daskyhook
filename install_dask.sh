#!/bin/bash
set -ex

scheduler_node=${1}
worker_nodes=${2}
IFS=',' read -r -a workers <<< "$worker_nodes"

ssh $scheduler_node docker run --privileged -d --restart on-failure --network host -p 8787:8787  ghcr.io/dask/dask dask-scheduler --interface eno1d1  

for worker in ${workers[@]}
do 
	ssh $worker "docker run --privileged -d --restart on-failure --network host -p 8787:8787  ghcr.io/dask/dask dask-worker --interface eno1d1 tcp://10.10.1.1:8786" 
done

