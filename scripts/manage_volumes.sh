#!/bin/bash
#
# Author: Glpskumar
# Date: 20-10-2025
# Description: This shell script verify the unused,availble voulmes and delete as per user request.

set +x
regions=$(aws ec2 describe-regions --query "Regions[].RegionName" --output text)

avail_voulmes() {
for region in $regions
do
    echo "* AWS Regions are: $region "
    volumes=$(aws ec2 describe-volumes --region $region --query "Volumes[].Attachments[].{VolumeId:VolumeId,State:State,Size:Size, InstanceID: InstanceId}" --output text)
    # volumes=$(aws ec2 describe-volumes --region $region --query Volumes[].VolumeId --output text)
    for volume in $volumes
	do
	    echo " $volume "
	done 
done
}

unused_volumes() {
for region in $regions
do
    echo "* AWS Regions are: $region "
    #avail_volumes=$(aws ec2 describe-volumes --region $region --filter "Name=status, Values=available" --query Volumes[].VolumeId --output text)
    #avail_volumes=$(aws ec2 describe-volumes --region $region --query "Volumes[?State!='in-use'].VolumeId" --output text)
    avail_volumes=$(aws ec2 describe-volumes --region $region --query 'Volumes[?Size<`5` && State==`available`].VolumeId' --output text)
    for avail_volume in $avail_volumes
    do
        echo "Unused Volume Id: $avail_volume "
    done
done    
}


remove_unused_volumes() {
for region in $regions
do
    echo "* AWS Regions are: $region "
    #avail_volumes=$(aws ec2 describe-volumes --region $region --filter "Name=status, Values=available" --query Volumes[].VolumeId --output text)
    # aws ec2 describe-volumes --region us-east-1 --query "Volumes[?State!='in-use'].VolumeId" --output text
    avail_volumes=$(aws ec2 describe-volumes --region $region --query 'Volumes[?Size<`5` && State==`available`].VolumeId' --output text)
    for avail_volume in $avail_volumes
    do
        echo "Unused Volume Id: $avail_volume"
        for del_volume in $avail_volume
        do
           echo " Detaching Volume id: $del_volume in $region"
           aws ec2 detach-volume --volume-id $del_volume --region $region
           echo " Deleting unused Volume id: $del_volume in $region"
           aws ec2 delete-volume --volume-id $del_volume --region $region
        done
    done
done
}

echo " Choose a option from below: "
echo " 1. List all volumes "
echo " 2. List Available_Unused volumes " 
echo " 3. Delete Available_Unused volumes "
read -p " Enter your choice (1 or 2 or 3): " choice

case $choice in
    1) 
        avail_voulmes
        ;;
    2) 
        unused_volumes
        ;;
    3)  
        remove_unused_volumes
        ;;
    *)
        echo " Invalid option selected. Please choose 1, 2, or 3. "
        ;;
esac