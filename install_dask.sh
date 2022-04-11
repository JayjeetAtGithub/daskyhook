#!/bin/bash
set -ex

worker_nodes=${1}
IFS=',' read -r -a workers <<< "$worker_nodes"

rm -rf dask
git clone https://github.com/uccross/dask
cd dask; git checkout support-skyhook
pip install --upgrade .[distributed,dataframe]
p=$(pidof dask-scheduler)
if [[ -z $p ]]; then
	echo "Dask scheduler is not running"
	exit 1
else
	echo "Dask scheduler is running; killing it"
	pkill $p
fi

for worker in ${workers[@]}
do 
	ssh $worker "rm -rf dask"
	ssh $worker "git clone https://github.com/uccross/dask"
	ssh $worker "cd dask; git checkout support-skyhook; pip install --upgrade .[distributed,dataframe]"
	ssh $worker "kill -z `pidof dask-worker`" || true
done

# nohup dask-scheduler --interface eno1d1 &
# nohup dask-worker --interface eno1d1 tcp://10.10.1.1:8786 &
