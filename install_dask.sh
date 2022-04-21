#!/bin/bash
set -ex

worker_nodes=${1}
IFS=',' read -r -a workers <<< "$worker_nodes"

kill $(pgrep dask-scheduler) || true
rm -rf dask
git clone https://github.com/uccross/dask
cd dask; git checkout support-skyhook
pip install --upgrade .[distributed,dataframe]

for worker in ${workers[@]}
do 
	ssh $worker "kill $(pgrep dask-worker) || true"
	ssh $worker "rm -rf dask"
	ssh $worker "git clone https://github.com/uccross/dask"
	ssh $worker "cd dask; git checkout support-skyhook; pip install --upgrade .[distributed,dataframe]"
done

# nohup dask-scheduler --interface eno1d1 &
# nohup dask-worker --interface eno1d1 tcp://10.10.1.1:8786 &


# dask-ssh 10.10.1.{1..9} --interface eno1d1 --ssh-username root --memory-limit="60 GiB"
# nohup dask-ssh 10.10.1.{1..9} --ssh-username root --memory-limit="60GiB" &