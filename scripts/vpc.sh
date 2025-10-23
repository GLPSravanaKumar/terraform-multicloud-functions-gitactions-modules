#!/bin/bash
#
# Author: Glpskumar
# Data: 20-10-2025
# Description: This shell script manages verify vpcs.

regions=$(aws ec2 describe-regions --query "Regions[].RegionName" --output text)
echo " Checking Active Default Vpcs and Custom Private vpcs in all Regions "

for region in $regions
do 
    echo "* AWS Region : $region "
    vpc=$(aws ec2 describe-vpcs --region $region --query 'Vpcs[?Tags[?key=='Cient' && value=='OPTUM'] ].VpcId ' --output text) 
    for vpcs in $vpc
    do 
        echo " $vpcs "
    done
done


regions=$(aws ec2 describe-regions --query "Regions[].RegionName" --output text)
echo " Checking Active Default Vpcs and Custom Private vpcs in all Regions "

for region in $regions
do
    echo "* AWS Region : $region "
    default_vpcs=$(aws ec2 describe-vpcs --region $region --query "Vpcs[?CidrBlock=='172.31.0.0/16'].VpcId" --output text)
    for default_vpc in $default_vpcs
    do
        echo "Default VPC: $default_vpc "
        custom_vpcs=$(aws ec2 describe-vpcs --region $region --query 'Vpcs[?Tags[?key=='Cient' && value=='OPTUM'] ].VpcId ' --output text)
        for custom_vpc in $custom_vpcs
        do
            echo " Custom VPC: $custom_vpc "
        done
    done
done