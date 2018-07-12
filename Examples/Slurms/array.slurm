#!/bin/bash
#script to run several copies of a sequential program
#with specified amount of copies per node

#SBATCH -J %name%
#SBATCH -o %name%-%j.out
#SBATCH -e %name%-%j.err

#SBATCH -N 2
##         ^ number of nodes
#SBATCH -a 0-1
##         ^ nodes' indexes

#SBATCH -t 00-10:00:00
##         ^ execution time limit

tasksPerNode=10
##           ^ amount of tasks per node
tasksTotal=20
##         ^ total amount of tasks

pids=""

firstTask=$((SLURM_ARRAY_TASK_ID * tasksPerNode))
lastTask=$((firstTask + tasksPerNode))

if [ "${lastTask}" -ge "${tasksTotal}" ]; then
    lastTask=${tasksTotal}
fi

folders=$(find ./Runs/ -maxdepth 1 -type d | tail -n +$((2 + ${firstTask})))

mkdir -p ./Runs

date "+Started at:%t%Y-%m-%d %H:%M:%S" > ./Runs/time.log

for folder in ${folders}; do
  pushd ${folder}
  
  ../../Executions/task > %name%.log 2>%name%.err &
  
  pids="${pids} $!"
  
  popd
done

wait $pids

date "+Finished at:%t%Y-%m-%d %H:%M:%S" >> ./Runs/time.log