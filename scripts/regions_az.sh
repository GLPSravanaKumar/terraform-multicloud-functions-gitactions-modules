#!/bin/bash
#
# Author: Glpskumar
# Date: 20-10-2025
# Description: This shell script manages verify regions and availability_zones.
set +x

regions=$(aws ec2 describe-regions --query "Regions[].RegionName" --output text)


for region in $regions;
do
    echo "#### AWS Global Available Regions are: $region ####"
    availability_zones=$(aws ec2 describe-availability-zones --region $region --query AvailabilityZones[].ZoneName --output text )
    for az in $availability_zones;
    do
        echo "AvilabilityZone is - $az"
    done
done



