#!/bin/bash
#
#
#

typeset EXEC_COMMAND_IN="./nc_exec_command_in.log"
typeset PORT_NUMBER="54321"
typeset SERVER_ADDRESS="localhost"

let queue=0

while true
do
    let queue+=1
        
    read -p " Enter remote command: " exec
    execID=`date +%y%m%d%T | tr -d "/:"`
    chksum=$(echo "["$execID-$queue"] "$exec | md5sum | tr -d ' -' )
    
    echo "["$execID-$queue"] "${exec} >> ${EXEC_COMMAND_IN}
    wait
    echo "["$execID-$queue"] "${chksum} | nc -q 0 ${SERVER_ADDRESS} ${PORT_NUMBER}
done
