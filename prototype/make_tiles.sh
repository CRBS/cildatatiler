#!/bin/bash

#$ -cwd
#$ -o /shared/tiffy/out/$JOB_ID.$TASK_ID.out
#$ -j y
#$ -S /bin/sh
#$ -pe smp 4

echo "HOST: $HOSTNAME"
file=`head -n $SGE_TASK_ID /shared/tiffy/tif/list | tail -n 1`

offset=`echo "$file" | sed "s/\.tif//"`

echo "Making tile for $file to ./tif/${offset}.tif"

/usr/bin/time -p /shared/CATMAID/scripts/tiles/tile_stack "$file" 256 256 $offset

offset=`echo "$file" | sed "s/\.tif//"`
echo "tarring dir $offset"
/usr/bin/time -p tar -c $offset > tars/${offset}.tar

if [ -d "$offset" ] ; then
  rm -rf $offset
fi

