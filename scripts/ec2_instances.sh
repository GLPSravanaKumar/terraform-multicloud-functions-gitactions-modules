#!/bin/bash
#
# Author: Glpskumar
# Data: 21-10-2025
# Description: This shell script manages verify and addition,deletion of Ec2_instances.

regions=$(aws ec2 describe-regions --query Regions[].RegionName --output text)
echo " Checking Active Instances in AWS Regions "
for region in $regions
do
    echo " * AWS Region $region "
    instances=$(aws ec2 describe-instances --region $region --query 'Reservations[].Instances[?InstanceType==`t2.micro`].InstanceId' --output text)
    for instance in $instances
    do 
        echo " $instance "
    done
done