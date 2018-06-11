#!/bin/bash

yum -y install epel-release ImageMagick parallel
pip install chmutil

. /etc/cfncluster/cfnconfig 

# $cfn_node_type is either MasterServer or ComputeFleet

if [ "${cfn_node_type}" == "MasterServer" ] ; then
  cd /shared

  # install imod
  echo "Installing IMOD to /shared"

  imodfile="imod_4.7.15_RHEL6-64_CUDA6.0.csh"
  wget http://bio3d.colorado.edu/imod/AMD64-RHEL5/$imodfile
  chmod a+x $imodfile
  ./$imodfile -yes -skip -dir /shared
  echo "export LD_LIBRARY_PATH=/lib64:/usr/lib64/mpich/lib:/shared/IMOD/lib:/usr/local/IMOD/qtlib" >> /home/centos/.bash_profile
  echo ". /shared/IMOD/IMOD-linux.sh" >> /home/centos/.bash_profile
  
  # install catmaid to /shared
  echo "Installing catmaid to /shared"
  cd /shared
  git clone https://github.com/catmaid/CATMAID.git
fi

