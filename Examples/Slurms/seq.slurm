#!/bin/bash
#script to run several copies of a sequential program

#SBATCH -J %name%
#SBATCH -o %name%-%j.out
#SBATCH -e %name%-%j.err

#SBATCH -n 10
##         ^ number of cores

#SBATCH -t 00-10:00:00
##         ^ execution time limit

mkdir -p ./Runs

date "+Started at:%t%Y-%m-%d %H:%M:%S" > ./Runs/time.log

srun -n 10 ./Executions/task
##      ^ number of cores

date "+Finished at:%t%Y-%m-%d %H:%M:%S" >> ./Runs/time.log