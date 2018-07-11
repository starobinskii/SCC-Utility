#!/bin/bash
#script to run several copies of a sequential matlab program

#SBATCH -J %name%
#SBATCH -o %name%-%j.out
#SBATCH -e %name%-%j.err

#SBATCH -n 10
##         ^ number of cores

#SBATCH -t 00-10:00:00
##         ^ execution time limit

module load matlab/2017a

matlab -nodisplay -r "run(), exit"
##                    ^ function to evaluate