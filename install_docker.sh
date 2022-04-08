#!/bin/bash
set -ex

node_list=${1}

IFS=', ' read -r -a nodes <<< "$node_list"

for node in ${nodes[@]}
do
	ssh $node "curl -o- https://get.docker.com | bash"
done

