#!/bin/bash
set -ex

node_list=${1}
IFS=',' read -r -a node_list <<< "$node_list"

for node in ${node_list[@]}
do	
        ssh $node mkdir -p /etc/ceph
 	scp /etc/ceph/ceph.conf $node:/etc/ceph/ceph.conf
	ssh $node apt update
	ssh $node apt install -y ceph-fuse
	ssh $node mkdir -p /mnt/cephfs
	ssh $node ceph-fuse /mnt/cephfs
done

