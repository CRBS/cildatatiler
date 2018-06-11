#!/bin/bash

#$ -t 1-644
#$ -cwd
#$ -o /shared/tiffy/out/$JOB_ID.$TASK_ID.out
#$ -j y
#$ -S /bin/sh

echo "HOST: $HOSTNAME"
file=`head -n $SGE_TASK_ID /shared/tiffy/list | tail -n 1`
echo "Converting $file to ./tif/${SGE_TASK_ID}.tif"

/usr/bin/time -p convert ${file} ./tif/${SGE_TASK_ID}.tif
