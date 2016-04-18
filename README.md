We have number of servers that share NFS mounts, and require mechanism for remote command execution. 

This is a poor man client/server prototype put together in couple days to satisfy the following principles: 

* robustness
* flexibility
* security

```
 [client]---->2:(commandID + CHKSUM)------>[server]---------------->5:(if CHKSUM matches and commandID has not been processed, execute the commandID)
                   |                                         |                                     ^
                   |                                         |                                     |
                   |                                         |                                     |
                   V                                         V                                     |
     1:(command ID + command string)       3:(using commandID, find the command string)---->4:(calculate CHKSUM)
                   |                                         |
                   |                                         |
                   |                                         |
                   V                                         |
             [NFS shared file]<------------------------------- 
```

1. Client generates command ID based on the following template: YYMMDDHHMMSS-[ascending integer]. It then logs both CommandID and CommandString into incoming command file, *nc_exec_command_in.log*
2. Client calculates CHKSUM for the command and communicates both CommandID and CommandCHKSUM to the server.
3. Once Server receives a message, it extract Command ID and CommandCHKSUM from it. Then, it locates a command string from the incoming command file, *nc_exec_command_in.log*, by CommandID lookup
4. Server calculates CommandCHKSUM.
5. Server compares received and calculated CommandCHKSUM, and if they match, execute the command by spawning a new process. The new process create a separate log file named with CommandID. As well, outgoing command file, *nc_exec_command_out.log*, is updated by appending CommandID and Command string.

If you need interactive command line client, use *nc_cleint.sh*

If you need to implement on you existing applicaiton, use python based *py_client.py* prototype and modify to fit your goals.
