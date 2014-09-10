#!/usr/bin/env bash

function check_result {
  if [ "0" -ne "$?" ]
  then
    echo $1
    exit 1
  fi
}

if [ -f $WORKSPACE/hudson/$REPO_BRANCH-setup.sh ]
then
  $WORKSPACE/hudson/$REPO_BRANCH-setup.sh
fi

. build/envsetup.sh
lunch $LUNCH
check_result lunch failed.

UNAME=$(uname)

LAST_CLEAN=0
if [ -f .clean ]
then
LAST_CLEAN=$(date -r .clean +%s)
fi
TIME_SINCE_LAST_CLEAN=$(expr $(date +%s) - $LAST_CLEAN)
# convert this to hours
TIME_SINCE_LAST_CLEAN=$(expr $TIME_SINCE_LAST_CLEAN / 60 / 60)
if [ $TIME_SINCE_LAST_CLEAN -gt "72" ]
then
echo "Cleaning!"
  touch .clean
  make clobber
else
echo "Skipping clean: $TIME_SINCE_LAST_CLEAN hours since last clean."
fi

if [ -z "$CLEAN_TYPE" ]
then
  echo CLEAN_TYPE not specified, assuming already clean
else
  mka $CLEAN_TYPE
fi

time mka carbon 2>&1 | tee "$LUNCH".log

ZIP=$(tail -3 "$LUNCH".log | cut -f3 -d ' ' | cut -f1 -d '"' |  sed -e '/^$/ d')
md5=$ZIP.md5sum
md5file=$(echo $ZIP | rev | cut -d"/" -f1-1 | rev).md5
rm -rf $WORKSPACE2/archive
mkdir $WORKSPACE2/archive
cp $ZIP $WORKSPACE2/archive
cp $md5 $WORKSPACE2/archive/$md5file
check_result Build failed
