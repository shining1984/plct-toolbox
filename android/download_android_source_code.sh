#!/bin/bash
set -ex
. /etc/profile

mkdir android
cd android
git config --global user.name shining
git config --global user.email shiningning@iscas.ac.cn
repo init -u https://android.googlesource.com/platform/manifest -b master
repo sync -c -j8