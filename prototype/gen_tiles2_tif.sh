#!/bin/bash

#$ -cwd
#$ -o /shared/tout/tile$JOB_ID.$TASK_ID.out
#$ -j y
#$ -S /bin/bash
#$ -pe smp 4
#$ -N tifgen

dest_basedir="/shared/tilerun"

cd "/shared"

echo "HOST: $HOSTNAME"
file=`head -n $SGE_TASK_ID /shared/tiflist | tail -n 1`

dest_dir="$dest_basedir/$file"
extract_img_dir="$dest_dir/images"
mkdir -p "$extract_img_dir"

fullfile="/shared/emdata/$file"

identify $fullfile | tail -n 1

echo "Running convert $fullfile $exract_img_dir/%d.tif to extract tiles"

/usr/bin/time -p convert $fullfile $extract_img_dir/%d.tif

if [ $? != 0 ] ; then
  echo "ERROR unable to extract tif images from tif stack"
  exit 1
fi

equalized_dir="$dest_dir/equalized"
mkdir -p "$equalized_dir"

cd $extract_img_dir

for Y in `/bin/ls *.tif` ; do
  echo "Converting $Y -equalize"
  /usr/bin/time -p convert $Y -equalize $equalized_dir/$Y
  rm $Y
done

rmdir $extract_img_dir
cd $equalized_dir

for Y in `/bin/ls *.tif` ; do
  echo $Y
  let x=`echo "$Y" | sed "s/\.tif$//"`
  /usr/bin/time -p /shared/CATMAID/scripts/tiles/tile_stack "$Y" 256 256 $x

  echo "tarring dir $x"
  /usr/bin/time -p tar -c $x > ${x}.tar

  if [ -d "$x" ] ; then
    echo "Removing ${x} directory"
    rm -rf $x
  fi
  /usr/bin/time -p aws s3 cp ${x}.tar s3://cil-cluster-bucket/cildata/catmaid/vtest/$file/${x}.tar --acl public-read
  echo "Removing ${x}.tar"
  rm ${x}.tar
done
cd ..
rm -rf $equalized_dir
cd ..
rmdir $dest_dir

