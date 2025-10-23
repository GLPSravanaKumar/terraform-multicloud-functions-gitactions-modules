#!/bin/bash
#
# Author: Glpskumar
# Data: 16-10-2025
# Description: This shell script verify the user status and create if users are not exists

set -x
# List of users to check/create
users=("dora" "bhadra" "vinitha" "sravan" "ram" "sita" "vinod" "sreedhar" "sreekar" "phani" "naga")
upper="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
lower="abcdefghijklmnopqrstuvwxyz"
number="0123456789"
symbol="!@#$%^&*()_+-=[]{}|'"
all="${upper}${lower}${number}${symbol}"


if [ $# -gt 0 ]
then
    for user in $@ ; do
        if [[ ! "$user" =~ ^[A-Za-z0-9+=,.@_-]{0,63}$ ]]; then
        echo " Invalid username. Use lowercase letters, digits or + = , . @ _ -, up to 64 chars."
        exit 1
        else
        # Check if user exists
        if id "$user" &>/dev/null; then       # "& = 2>&1"
            echo "User '$user' already exists."
        else
            # Create the user
            echo "User $user does not exist. Creating user $user."
            sudo useradd -m -s /bin/bash "$user"  #up to 64 Valid characters: A-Z,a-z,0-9,and+=,. @ _ - (hyphen)
            #for i in $(openssl rand -base64 "${BYTES}" | head -c "${LENGTH}"); do echo " $i"; done
            #for i in $(< /dev/urandom tr -dc 'A-Za-z0-9!@#$%^&*()_+-=' | head -c 8) ; do echo " $i"; done
            password=$(echo "$(echo "${upper:0:1}${lower:0:1}${number:0:1}${symbol:0:1}"$(echo "$all" | fold -w1 | shuf | head -n4 | tr -d '\n'))" | fold -w1 | shuf | tr -d '\n' | head -c8)
            echo "$user:$password" | sudo chpasswd
            sudo passwd -e "$user"
            echo "🔐 Temporary password: $password"
            echo "⚠️  User must change password at next login."

        fi  
        fi 
    done
else
    echo " No arguments provided. Please provide at least one username. Ex: bash *.sh bhadra"
fi

# Custom password:
# Must be at least 8 characters long. 
# Must include at least three of the following mix of character types: #uppercase letters (A-Z), lowercase  # letters (a-z), numbers (0-9), and symbols ! @ # $ % ^ & * ( ) _ + - (hyphen) = [ ] { } | '
#  Console password : aV0%7p6C