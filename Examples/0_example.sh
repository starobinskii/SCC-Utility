#!/bin/bash
#Inherited version: 1.0

#set folder to work with
exampleTask="#><#"
dir="#>dirname<#"

#test if this is an example
if [ "#><#" == "${exampleTask}" ]; then
    tput bold
    tput setaf 1
    echo "This is an example! No actual work will be done."
    tput sgr0
    echo "Also remember to run this script from ~/ (your home folder)."
    echo ""
    dir="Utilities/Examples/Project" 
fi

#get home path
rootDir=$(cd $(dirname $0) && pwd)

#load user config
source ${rootDir}/user.cfg

#load project config
source ${rootDir}/${dir}/project.cfg

#set command to start this script
startScript="${rootDir}/$(basename $0)"

#now use variables from project.cfg

#print title
tput bold
tput setaf 5
echo "    vv\"\"\"vvv\"\"\"vvv\"\"\"vvv\"\"\"vvv\"\"\"vv"
echo -n " -> | "
tput setaf 6
echo -n "${projectTitle}"
tput setaf 5
echo " | <-"
echo "    ^^~~~^^^~~~^^^~~~^^^~~~^^^~~~^^"
tput sgr0

#go to the project directory
cd ${rootDir}/${projectDir}
echo "Starting..."

#compile sources
compilationResult=$(compileTask)

if [[ "0" !=  "${compilationResult}" ]]; then
    tput bold
    tput setaf 1
    echo "Cannot compile. Exiting..."
    tput sgr0
    exit 1
fi

tput bold
tput setaf 2
echo "Compiled task."
tput sgr0

jobid=0
#test if this is not an example
if [ "#><#" != "${exampleTask}" ]; then
    #start calculations and get its id
    jobid=$(sbatch ./Executions/job.slurm | gawk '{print $4}')
fi
echo -n "JOBID: "
tput bold
tput setaf 4
echo "${jobid}"
tput sgr0

#exit if id is incorrect
if [[ "${jobid}" =~ "^[\d]+(_[\d]+)?$" ]]; then
    tput bold
    tput setaf 1
    echo "Got an error in jobid. Exiting..."
    tput sgr0
    exit 2
fi

#TODO: if an array job run several daemons

echo "Computing..."
#test if this is not an example
if [ "#><#" != "${exampleTask}" ]; then
    #check if daemon can handle the job
    if [ "array" = "${projectType}" && "1.0" = "$(${rootDir}/Utilities/daemon.sh -v)"]; then
        echo "Current version of SCC Daemon is incompatible with an array job. Wait for an update."
        
        exit 0
    else
        #start the Daemon
        nohup ${rootDir}/Utilities/daemon.sh ${jobid} ${dir} ${startScript} < /dev/null &
    fi
fi

tput bold
echo -n "You will be notified."

#test if this is not an example
if [ "#><#" == "${exampleTask}" ]; then
    tput setaf 1
    echo -n " (no, actually)"
fi
echo ""
tput sgr0

exit 0