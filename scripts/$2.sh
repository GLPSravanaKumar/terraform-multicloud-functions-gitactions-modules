#!/bin/bash
#
# Author: Glpskumar
# Data: 22-10-2025
# Description: This shell script is to verify attributes "$2".
#!/bin/bash
if [ $# -gt 0 ];
then
  vpcs=$(aws ec2 describe-vpcs --region $1 --query "Vpcs[?CidrBlock=='$2'].VpcId " --output text)
  if [ -n "$vpcs" ];
  then
    for vpc in $vpcs
    do
      echo " $vpc "
    done
  else
    echo " Hello there, no default VPC's in selected region: $1 "
  fi
else
  echo "You have entered $# parameters, please enter atleast one org Ex: bash *.sh us-east-1 us-east-2"
fi
