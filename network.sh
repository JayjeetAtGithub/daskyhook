#!/bin/bash
set -ex

node_list=${1}
IFS=',' read -r -a node_list <<< "$node_list"

apt update
apt install -y wondershaper
sudo wondershaper clear eno1d1
sudo wondershaper eno1d1 10240000 10240000

for node in ${node_list[@]}
do	
    ssh $node "apt update"
    ssh $node "apt install -y wondershaper"
    ssh $node "sudo wondershaper clear eno1d1"
    ssh $node "sudo wondershaper eno1d1 10240000 10240000"
done
