#!/bin/bash

cmd=$1
shift

server_list=$*

if [ -z "$cmd" ] ; then
    echo "Error: Argument cmd is missing!"
    echo "Usage: $0 {cmd} [server1 server2 ...]"
    exit 1
fi

function run_cmd()
{
    local s=$1   #server
    shift
    local c=$*   #cmd

    echo ssh -p 55667 root@$s $c
    ssh -p 55667 root@$s $c

    return $?
}

if [ -z "$server_list" ] ; then
    for server in `cat servers.txt` ; do
        run_cmd $server $cmd
        #[ $? -ne 0 ] && echo "Failed" && exit
    done
else
    for server in $server_list ; do
        run_cmd $server $cmd
        #[ $? -ne 0 ] && echo "Failed" && exit
    done
fi

echo "Succeeded"
