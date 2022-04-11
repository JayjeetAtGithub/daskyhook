#!/bin/bash
set -ex

worker_nodes=${1}
IFS=',' read -r -a workers <<< "$worker_nodes"


git clone https://github.com/uccross/dask
cd dask; git checkout support-skyhook
pip install --upgrade .

for worker in ${workers[@]}
do 
	ssh $worker "git clone https://github.com/uccross/dask"
	ssh $worker "cd dask; git checkout support-skyhook"
	ssh $worker "pip install --upgrade ."
done

# nohup dask-scheduler --interface eno1d1 &
# nohup dask-worker --interface eno1d1 tcp://10.10.1.1:8786 &
