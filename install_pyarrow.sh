#!/bin/bash
set -ex

node_list=${1}
IFS=',' read -r -a node_list <<< "$node_list"

for node in ${node_list[@]}
do
	ssh $node apt update 
	ssh $node apt install -y python3-pip 
	scp /tmp/arrow/python/dist/*.whl $node:/users/noobjc
	ssh $node pip install /users/noobjc/*.whl
done
