#!/bin/bash
set -ex

worker_nodes=${1}
IFS=',' read -r -a workers <<< "$worker_nodes"

dask-scheduler --interface eno1d1

for worker in ${workers[@]}
do 
	ssh $worker "dask-worker --interface eno1d1 tcp://10.10.1.1:8786"
done
