#!/bin/bash

TFCOMMON="../tfcommon"

RESOURCES="
security_group_admiral
security_group_bastion
security_group_dockerhub
security_group_docker-ext-elb
security_group_etcd
security_group_hosting
security_group_rds
subnet_ext_elb-us-west-2a
subnet_ext_elb-us-west-2b
subnet_ext_elb-us-west-2c
subnet_rds-us-west-2a
subnet_rds-us-west-2b
subnet_rds-us-west-2c
subnet_admiral-us-west-2a
subnet_admiral-us-west-2b
subnet_admiral-us-west-2c
subnet_bastion-us-west-2a
subnet_bastion-us-west-2b
subnet_bastion-us-west-2c
subnet_etcd-a-us-west-2a
subnet_etcd-b-us-west-2b
subnet_etcd-c-us-west-2c
subnet_hosting-us-west-2a
subnet_hosting-us-west-2b
subnet_hosting-us-west-2c
vpc_cidr
vpc_id"

NETWORKTFVARS="${TFCOMMON}/network.tfvars"
install -v /dev/null $NETWORKTFVARS
for i in $RESOURCES
do
  echo -n "$i=" >> $NETWORKTFVARS
  echo $i
  terraform output $i >> $NETWORKTFVARS
done
