#!/bin/bash
#
# Author: Glpskumar
# Data: 20-10-2025
# Description: This shell script manages verify regions and availability_zones.
set +x

regions=$(aws ec2 describe-regions --query "Regions[].RegionName" --output text)

fn_region(){
for region in $regions;
do
    echo "* AWS Regions are: $region "
done
}

fn_availability-zones() {
for region in $regions;
do
    echo "* AWS Regions are: $region "
    availability_zones=$(aws ec2 describe-availability-zones --region $region --query AvailabilityZones[].ZoneName --output text )
    for az in $availability_zones;
    do
        echo " * $az"
    done
done
}

fn_subnets_ids(){
    for region in $regions;
do
    echo "* AWS Regions are: $region "
    subnet_ids=$(aws ec2 describe-subnets --region $region --query Subnets[].SubnetId --output text)
    for subnet_id in $subnet_ids;
    do
        echo " * $subnet_id"
    done
done
}




echo "Choose an action:"
echo "1: Regions"
echo "2: Availability_Zones"
echo "3: Subnets"
read -p "Enter your choice (1 or 2 or 3): " choice

case $choice in
    1) 
        fn_region
        ;;
    2) 
        fn_availability-zones
        ;;
    3)  
        fn_subnets_ids
        ;;
    *)  
        echo "Invalid choice. Please enter 1,2 or 3."
        ;;
esac