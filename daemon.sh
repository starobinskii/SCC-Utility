#!/bin/bash

if [[ "-v" = "${1}" || "--version" = "${1}" ]]; then
    echo "1.0"
    
    exit
fi

jobid=$1
dir=$2
startScript=$3
shift 3

#exit if id is incorrect
if [[ "${jobid}" =~ "^[\d]+(_[\d]+)?$" ]]; then
    tput bold
    tput setaf 1
    echo "Got an error in jobid. Exiting..."
    tput sgr0
    exit 1
fi

#get home path
rootDir=$(cd $(dirname $0) && pwd)

#load user config
source ${rootDir}/user.cfg

#load project config
source ${rootDir}/${dir}/project.cfg

parametersQueue="${baseDir}/${projectDir}/${projectQueue}"

job=$(squeue | grep "${jobid}")
name=$(echo ${job} | awk '{print $3}')
newTime=0
	
until [ -z "${newTime}" ]; do
	sleep 10s
	time=${newTime}
	job=$(squeue | grep "${jobid}")
	newTime=$(echo ${job} | awk '{print $6}')
done

echo "Done."

read parameters < "${parametersQueue}"

setNotificationText "${jobid}" "${name}" "${time}" "${parameters}" "$@"

notify "message=${notificationText}"

if [ "-" != "${parameters}" ]; then
    exec "${startScript}"
fi
