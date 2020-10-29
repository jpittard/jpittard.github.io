#!/bin/bash

# Background the process
ctrl-z
bg %1
disown -h %1
ctrl-d

# from https://stackoverflow.com/questions/593724/redirect-stderr-stdout-of-a-process-after-its-been-started-using-command-lin

pid=$(cat /var/run/app/app.pid)
logFile="/var/log/app.log"

reloadLog()
{
    if [ "$pid" = "" ]; then
        echo "invalid PID"
    else
        gdb -p $pid >/dev/null 2>&1 <<LOADLOG
p close(1)
p open("$logFile", 1)
p close(2)
p open("$logFile", 1)
q
LOADLOG
        LOG_FILE=$(ls /proc/${pid}/fd -l | fgrep " 1 -> " | awk '{print $11}')
        echo "log file set to $LOG_FILE"
    fi
}

reloadLog
