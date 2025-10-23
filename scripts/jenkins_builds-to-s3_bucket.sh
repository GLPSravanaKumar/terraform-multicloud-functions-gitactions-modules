#!/bin/bash
#
# Author: Glpskumar
# Data: 18-10-2025
# Description: This shell script uploads Jenkins build artifacts & logs to an S3 bucket.
# Version: v0.0
set +x

# ---------- CONFIGURATIONS ---------- #
S3_BUCKET="s3://uhg-s3-backend-table"
JENKINS_HOME="/var/lib/jenkins/"
TIMESTAMP=$(date +"%Y-%m-%d %H-%M-%S")

# Check if aws cli is installed #
if ! command -v aws &> /dev/null
then
    echo "AWS CLI could not be found, please install it."
    exit 1
fi

for job_dir in "${JENKINS_HOME}/jobs/"*; do
    job_name=$(basename "$job_dir")
    echo " job directory is: $job_dir"
    echo " job_name is: $job_name"

   for build_dir in "${job_dir}/builds/"*; do
       build_number=$(basename "$build_dir")
       log_file="${build_dir}/log"
       echo " Build Directory is: $build_dir "
       echo " Build_Number is: $build_number "
       echo " Log_File is: $log_file "

       if [ -f "$log_file" ]; then
          aws s3 cp "${log_file}" "${S3_BUCKET}/jenkins/$job_name-$build_number-$TIMESTAMP.log" --region us-east-1 --only-show-errors
       else
          echo "Log File does not exists, please verify ... "
       fi
   done
done