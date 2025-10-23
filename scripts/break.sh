#!/bin/bash
set +x
regions=(ap-south-2 us-east-1 us-west-1 ap-south-1 eu-north-1 eu-west-3)

for region in "${regions[@]}"
do
  echo "#### AWS Global Available Regions are: $region ####"
  vpcs=$(aws ec2 describe-vpcs --region $region --query Vpcs[].VpcId --output text )
  if [ -n "$vpcs" ]         # true if value is not zero
  then
    for vpc in $vpcs
    do
      echo " $vpc "
    done
  else
    echo " No Vpc fund in region $region "
    break
  fi
done