#!/bin/bash

#$ -cwd
#$ -o /shared/emdata/out/$JOB_ID.$TASK_ID.out
#$ -j y
#$ -S /bin/sh
#$ -pe smp 4

echo "HOST: $HOSTNAME"
file=`head -n $SGE_TASK_ID list | tail -n 1`


echo "Downloading $file"

/usr/bin/time -p wget $file

