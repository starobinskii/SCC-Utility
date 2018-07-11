#!/bin/bash
#script to run a parallel program (MPI)

#SBATCH -J %name%
#SBATCH -o %name%-%j.out
#SBATCH -e %name%-%j.err

#SBATCH -n 10
##         ^ number of cores

#SBATCH -t 00-10:00:00
##         ^ execution time limit

mpiexec.hydra ./Executions/task
