#!/bin/bash
set -ex

node_list=${1}

IFS=', ' read -r -a nodes <<< "$node_list"

# install on client node
curl -o- https://get.docker.com | bash

# install on cluster nodes
for node in ${nodes[@]}
do
	ssh $node "curl -o- https://get.docker.com | bash"
done

