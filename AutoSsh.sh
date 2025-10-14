
# Path to your servers file
file="./ssh_connect_servers.txt"


privateKey=$(cat ssh_connect_servers.txt | awk -F "@" '{print $1}' | awk -F ":" '{print $2 $3}')
server=$(cat ssh_connect_servers.txt | awk -F "@" '{print $2}')

echo $privateKey
echo $server

echo "Connecting to $server using $privateKey..."
"$privateKey"@"$server"    
    



