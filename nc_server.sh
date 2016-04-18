#!/bin/bash
#
#
#
#

typeset EXEC_COMMAND_IN="./nc_exec_command_in.log"
typeset EXEC_COMMAND_OUT="./nc_exec_command_out.log"
typeset PORT_NUMBER="54321"
typeset REMOTE_EXEC_LOG_DIR="./remote_exec_log"

[ -d ${REMOTE_EXEC_LOG_DIR} ] || mkdir -p ${REMOTE_EXEC_LOG_DIR}

while true
do
    exec_line=$(nc -l -q 0 -p ${PORT_NUMBER} )

    # extract command ID from the received string
    command_id=$(echo ${exec_line} | egrep -o \[[0-9-]*\] | tr -d "[]" )
    # repeated commandID execution is not allowed
    if ( grep "^\["${command_id} ${EXEC_COMMAND_OUT} )
    then
	    echo "ERR02: CommandID: ["${command_id}"] has been processed already"
	    continue
    fi

    # find the command from the log file matching its ID above
    exec_command=$(grep ${command_id} ${EXEC_COMMAND_IN} | cut -d ']' -f 2 )
    
    # calculate CHKSUM on the command string
    calc_chksum=$(echo "["${command_id}"]"${exec_command} | md5sum | tr -d ' -')
    
    # extract CHKSUM from the received string
    rcv_chksum=$(echo $exec_line | cut -d ']' -f 2 | tr -d ' ')

    timestamp=`date +%y%m%d%T | tr -d ':'`
    # compare calculated and received CHSUMs
    if [[ "X"${calc_chksum} == "X"${rcv_chksum} ]]
    then
	    echo "["$command_id"] ["${timestamp}"] "${exec_command} | tee -a ${EXEC_COMMAND_OUT}
	    eval "${exec_command}" 2>&1 > ${REMOTE_EXEC_LOG_DIR}"/"${command_id}".log" &
    else
	    echo "ERR01: CHKSUM comparison failed on command ID "${command_id} | tee -a ${EXEC_COMMAND_OUT}
	  fi
	done 
    
