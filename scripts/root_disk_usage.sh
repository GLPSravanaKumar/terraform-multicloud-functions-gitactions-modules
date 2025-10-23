#!/bin/bash

limit=80
free_memory=$(df -h | grep -E "/dev/root" | awk '{print $5 " "}' | sed "s/%//g")
if [ $free_memory -ge $limit ]; then
  echo "Root storage used is above ${limit}%: current usage is ${free_memory}%"
else
  echo "Enough Disk storage ${free_memory}% is available"
fi