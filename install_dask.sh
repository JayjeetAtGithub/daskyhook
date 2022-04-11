#!/bin/bash
set -ex

worker_nodes=${1}
IFS=',' read -r -a workers <<< "$worker_nodes"

pip install dask[distributed,dataframe]

for worker in ${workers[@]}
do 
	ssh $worker "pip install dask[distributed,dataframe]"
done

# dask-scheduler --interface eno1d1
# dask-worker --interface eno1d1 tcp://10.10.1.1:8786