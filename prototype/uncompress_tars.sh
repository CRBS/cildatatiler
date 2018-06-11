#!/bin/bash

#$ -cwd
#$ -o /shared/uout/tar$JOB_ID.$TASK_ID.out
#$ -j y
#$ -S /bin/bash
#$ -pe smp 4

dest_basedir="/shared/uncompressedemdata"

cd "/shared"

echo "HOST: $HOSTNAME"
file=`head -n $SGE_TASK_ID /shared/tarziplist | tail -n 1`

suffix=`echo $file | sed "s/^.*\.//"`

dest_dir="$dest_basedir/$file"
mkdir -p "$dest_dir"

fullfile="/shared/emdata/$file"

echo "Uncompressing $fullfile to $dest_dir"
cd $dest_dir
/usr/bin/ln $fullfile $file



if [ "$suffix" == "tar" ] ; then
  /usr/bin/time -p tar -xf $file
  rm "$dest_dir/$file"
  exit $?
fi

if [ "$suffix" == "zip" ] ; then
  /usr/bin/time -p unzip -n $file
  rm "$dest_dir/$file"
  exit $?
fi


echo "Unknown suffix $suffix for file $file"
exit 50
