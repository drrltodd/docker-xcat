#! /bin/bash

# Script to run to save state

. /etc/profile.d/xcat.sh

dumpxCATdb -p /.dbbackup/

mkdir -p /install/.root
rsync -aHSpv /root/.ssh /root/.xcat /install/.root

mkdir -p /install/.etcssh
cp /etc/ssh/*key* /install/.etcssh
