#!/bin/bash
#
# Author: Glpskumar
# Data: 16-10-2025
# Description: This shell script manages verify status and addition,deletion of users.
set -x

# List of users to check/create
users=("dora" "bhadra" "vinitha" "sravan" "ram" "sreedhar" "sreekar" "phani" "naga")

# Verify users status
verify_users(){
    for user in "${users[@]}"
    do
      if id "$user" &>>/home/ubuntu/output_users.txt
      then
          echo "User $user exists"
      else
           echo "User $user does not exist"
       fi
    done
}
# Create users if not exists
create_users(){
    for user in "${users[@]}"; do
        # Check if user exists
        if id "$user" &>>/home/ubuntu/output_users.txt; then       # "& = 2>&1"
            echo "User '$user' already exists."
        else
            # Create the user
            echo "User $user does not exist. Creating user $user."
            sudo useradd -m -s /bin/bash "$user"
            echo "User '$user' has been created."
        fi
    done
} 
# Function to delete users
delete_users(){
    for user in "${users[@]}"; do
        # Check if user exists
        if id "$user" &>>/home/ubuntu/output_users.txt; then
            echo "User '$user' exists.Deleting user $user."
            sudo userdel -r "$user"
            echo "User '$user' has been deleted."
        else
            echo "User '$user' does not exist."
        fi
    done
}

# checking users directory
verify_user_homediectory (){
    echo "Verify Users Directory"
    for user in "${users[@]}"; do
        if [ -d /home/"${user}" ] 2>/dev/null; then
            echo "User ${user} Home Directory '/home/ubuntu/${user}' exists."
        else
            echo "User ${user} Home  Directory '/home/ubuntu/${user}' does not exist.Choose choice 2 for creating user with directory"
        fi
    done
    sudo ls /home/
}

# Call the functions
echo "Choose an action:"
echo "1. Verify Users"
echo "2. Add Users"
echo "3. Delete Users"
echo "4. Verify User Home_directory"
read -p "Enter your choice (1 or 2 or 3 or 4): " choice

case $choice in
    1)
        verify_users         # here 1 is represent/echos fn verify_users (user enter 1 it calls verify_users)
        ;;
    2)
        create_users
        ;;
    3)
        delete_users
        ;;
    4)
        verify_user_homediectory
        ;;
    *)
        echo "Invalid choice. Please enter 1, 2, 3 or 4 ."
        ;;
esac

