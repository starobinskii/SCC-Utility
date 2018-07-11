#!/bin/bash

name=""
shortName=""

language=""
compiler=""
interpreter=""
parallelization=""

#set the project name
echo -n "Name your project (max 16 letters): "
read line
name=$(echo "${line}" | tr '[ -@#!?:\\/\^\$%\(\)\*|]' '_' | sed -r 's/_([a-z])/\U\1/gi' | sed -r 's/^([A-Z])/\l\1/' | tr -d '_' | cut -c1-16)
shortName=$(echo "${name}" | tr -d '[0-9aeioquy]' | cut -c1-6)

echo "Project name \"${name}\"."
echo "Short name: \"${shortName}\"."

while true; do
    read -p "Register project? [Y/n]: " yn
    case ${yn} in
        [Nn]* )
            echo "Registration has been canceled. Exiting..."
            exit
            ;;
        * ) 
            tput bold
            echo -e "\nStating new project..."
            tput sgr0
            break
            ;;
    esac
done

#set the language
echo -e "\nChoose your language"
options=("C" "C++" "Python" "Matlab")
options=("C" "C++")
select opt in "${options[@]}"
do
    case $opt in
        "C")
            language="c"
            compiler=""
            interpreter=""
            tput bold
            echo "Set."
            tput sgr0
            break
            ;;
        "C++")
            language="c++"
            compiler=""
            interpreter=""
            tput bold
            echo "Set."
            tput sgr0
            break
            ;;
        # "Python")
        #     language="python"
        #     compiler=""
        #     interpreter=""
        #     tput bold
        #     echo "Set."
        #     tput sgr0
        #     break
        #     ;;
        # "Matlab")
        #     language="matlab"
        #     compiler=""
        #     interpreter="matlab"
        #     tput bold
        #     echo "Set."
        #     tput sgr0
        #     break
        #     ;;
        *) echo "Invalid option ${REPLY}."
            ;;
    esac
done

#set the parallelization method
if [[ "c" = "${language}" || "c++" = "${language}" ]]; then
    echo -e "\nHow your program is running?"
    options=("MPI" "Sequential" "Array")
    select opt in "${options[@]}"
    do
        case $opt in
            "MPI")
                parallelization="mpi"
                if [ "c" = "${language}" ]; then
                    compiler="mpicc"
                else
                    compiler="mpicxx"
                fi
                interpreter=""
                tput bold
                echo "Set."
                tput sgr0
                break
                ;;
            "Sequential")
                parallelization="seq"
                tput bold
                echo "Set."
                tput sgr0
                break
                ;;
            "Array")
                parallelization="array"
                tput bold
                echo "Set."
                tput sgr0
                break
                ;;
            *) echo "Invalid option ${REPLY}."
                ;;
        esac
    done
fi

#set the environment
if [[ "c" = "${language}" && -z "${compiler}" ]]; then
    echo -e "\nWhich compiler should we use?"
    options=("Intel (icc)" "GNU (gcc)")
    select opt in "${options[@]}"
    do
        case $opt in
            "Intel (icc)")
                compiler="icc"
                interpreter=""
                tput bold
                echo "Set."
                tput sgr0
                break
                ;;
            "GNU (gcc)")
                compiler="gcc"
                interpreter=""
                tput bold
                echo "Set."
                tput sgr0
                break
                ;;
            *) echo "Invalid option ${REPLY}."
                ;;
        esac
    done
elif [[ "c++" = "${language}" && -z "${compiler}" ]]; then
    echo -e "\nWhich compiler should we use?"
    options=("Intel (icpc)" "GNU (g++)")
    select opt in "${options[@]}"
    do
        case $opt in
            "Intel (icpc)")
                compiler="icpc"
                interpreter=""
                tput bold
                echo "Set."
                tput sgr0
                break
                ;;
            "GNU (g++)")
                compiler="g++"
                interpreter=""
                tput bold
                echo "Set."
                tput sgr0
                break
                ;;
            *) echo "Invalid option ${REPLY}."
                ;;
        esac
    done
# elif [ "python" = "${language}" ]; then
#     echo -e "\nWhat version of Python is needed?"
#     options=("Python 2" "Python 3")
#     select opt in "${options[@]}"
#     do
#         case $opt in
#             "Python 2")
#                 compiler=""
#                 interpreter="python2"
#                 tput bold
#                 echo "Set."
#                 tput sgr0
#                 break
#                 ;;
#             "Python 3")
#                 compiler=""
#                 interpreter="python3"
#                 tput bold
#                 echo "Set."
#                 tput sgr0
#                 break
#                 ;;
#             *) echo "Invalid option ${REPLY}."
#                 ;;
#         esac
#     done
fi

projectDir="${HOME}/${name}"

#creating project directory
mkdir -p ${projectDir}

cp -r ~/Utilities/Examples/Project/* ${projectDir}/

#modifying project configuration
configuration="${projectDir}/project.cfg"
configurationSource="${projectDir}/project.cfg.sed"

mv ${configuration} ${configurationSource}

sed -e "s/%compiler%/${compiler}/g" ${configurationSource} | sed -e "s/%type%/${parallelization}/" | sed -e "s/%shortName%/${shortName}/" | sed -e "s/%name%/$(printf %16s ${name})/" | sed -e "s/%projectDir%/${name}/" > ${configuration}

rm -f ${configurationSource}

#creating slurm script
mkdir -p "${projectDir}/Executions"
slurm="${projectDir}/Executions/job.slurm"
slurmSource="${projectDir}/Executions/job.slurm.sed"

cp ~/Utilities/Examples/Slurms/${parallelization}.slurm ${slurmSource}

sed -e "s/%name%/${shortName}/g" ${slurmSource} > ${slurm}

rm -f ${slurmSource}

#creating start script
index=$(cd ~/; ls -1 ./*.sh | awk '/^.\/[0-9]+_/ {print}' | wc -l)
echo -e "\nFound ${index} start script(s)."
index=$((${index} + 1))
startScript="${HOME}/${index}_${name}.sh"
startScriptSource="${HOME}/${index}_${name}.source"

cp ~/Utilities/Examples/0_example.sh ${startScriptSource}

sed -e 's/exampleTask="#><#"/exampleTask=""/' ${startScriptSource} | sed -e "s/dir=\"#>dirname<#\"/dir=\"${name}\"/" > ${startScript}

rm -f ${startScriptSource}

chmod +x ${startScript}

echo -e "\nEverything is ready. Now:"
tput bold
echo "1) upload your sources to the folder:"
tput sgr0
echo "    ${projectDir}/Sources"
tput bold
echo "2) specify number of cores in:"
tput sgr0
echo "    ${projectDir}/Executions/job.slurm"
tput bold
echo "3) start calculations with the following command:"
tput sgr0
echo "    ~/${index}_${name}.sh"