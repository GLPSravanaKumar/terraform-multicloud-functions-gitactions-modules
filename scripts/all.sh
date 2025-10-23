#!/bin/bash
#
# Author: Glpskumar
# Data: 21-10-2025
# Description: This shell script manages verify regions and availability_zones.
set +x

fn_availability_zones(){
echo
echo "** AWS Region is $region **"
echo
echo "Listing the Availability_Zones in region $region"
availability_zones=$(aws ec2 describe-availability-zones --region $region --query AvailabilityZones[].ZoneName --output text )
if [ -z "$availability_zones" ]
then
    echo "No AvailabilityZones found in region $region "
else
for az in $availability_zones
do
    echo "Availability_zone: $az "
done
fi   
}

fn_subnets_ids(){
echo
echo "Listing the Subnets in region $region"
subnet_ids=$(aws ec2 describe-subnets --region $region --query Subnets[].SubnetId --output text)
if [ -z "$subnet_ids" ]
then
    echo "No Subnets found in region $region "
else
for subnet_id in $subnet_ids
do
   echo " Subnet: $subnet_id"
done
fi
}

fn_vpcs(){
echo
echo "Listing Default & Custom Private VPCs in region $region "
default_vpcs=$(aws ec2 describe-vpcs --region $region --query "Vpcs[?CidrBlock=='172.31.0.0/16'].VpcId" --output text)
if [ -z "$default_vpcs" ]
then
    echo "No Default VPCs found in region $region "
else
for default_vpc in $default_vpcs
do
  echo "Default VPC: $default_vpc "
  custom_vpcs=$(aws ec2 describe-vpcs --region $region --query 'Vpcs[?Tags[?key=='Cient' && value=='OPTUM'] ].VpcId ' --output text)
  if [ -z "$custom_vpcs" ]
  then
    echo "No Custom VPCs found in region $region "
  else
  for custom_vpc in $custom_vpcs;
  do
    echo " Custom VPC: $custom_vpc "
  done
  fi
done
fi
}

fn_instances(){
echo
echo "Listing active Instances in region $region"
instances=$(aws ec2 describe-instances --region $region --query 'Reservations[].Instances[?InstanceType==`t2.micro`].InstanceId' --output text)
if [ -z "$instances" ]
then
    echo "No Instances found in region $region "
else
for instance in $instances;
do
  echo "InstanceID: $instance "
done
fi
}

for region in $(aws ec2 describe-regions --query "Regions[].RegionName" --output text);
do
    fn_availability_zones $region
    fn_subnets_ids $region
    fn_vpcs $region
    fn_instances $region
done