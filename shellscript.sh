#!/bin/bash

instance_id=$(curl http://169.254.169.254/latest/meta-data/instance-id)



total_size=$(df -h | awk '$6 == "/" {print $2}')
available_space=$(df -h | awk '$6== "/" {print $4}')
echo "Total size is: $total_size and available space on the Root_drive : $available_space"


if  [ $available_space -lt 3G ];
then
    echo "Not enough Space on root drive, available space is $available_space "
    curl -X POST -sL -H 'Content-type: application/json' --data "{"text": \"Total size is: ${total_size} and available space on the Root_drive: ${available_space}\"}" ${slack_web}
  
else
    echo "Enough space on root drive, available space is $available_space"
    curl -X POST -sL -H 'Content-type: application/json' --data "{"text": \"Enough space on root drive, available space is: ${available_space}\"}" ${slack_web}
fi