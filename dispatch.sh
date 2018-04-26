#!/bin/bash

localfile=$1
remotedir=$2
shift 2

server_list=$*

if [ -z "$localfile" -o -z "$remotedir" ] ; then
    echo "Error: Argument local-file or remote-dir is missing!"
    echo "Usage: $0 {local-file} {remote-dir} [server1 server2 ...]"
    exit 1
fi

function remote_copy()
{
    local s=$1   #server
    local f=$2   #local file
    local d=$3   #remote dir

    if [ -d $f ] ; then
        echo scp -P 55667 -r $f root@$s:$d
        scp -P 55667 -r $f root@$s:$d
        return $?
    elif [ -f $f ] ; then
        echo scp -P 55667 $f root@$s:$d
        scp -P 55667 $f root@$s:$d
        return $?
    else
        #Yuanguo: symbol link, pipe, socket files are not supported yet!
        echo "Error: $f is not a file or directory!"
        return 1
    fi  
}


if [ -z "$server_list" ] ; then
    for server in `cat servers.txt` ; do
        remote_copy $server $localfile $remotedir
        [ $? -ne 0 ] && echo "Failed" && exit
    done
else
    for server in $server_list ; do
        remote_copy $server $localfile $remotedir
        [ $? -ne 0 ] && echo "Failed" && exit
    done
fi

echo "Succeeded"
