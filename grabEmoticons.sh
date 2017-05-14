#!/bin/bash

# Copyright 2017 Chip Wasson

function usage {
  echo "Usage: $0 <file containing source of emoticon page>"
  exit 2
}


if [ ! $# -eq 1 ]
then
  usage
fi

source=`cat $1`

urls=`egrep -oE "data-original=\"([^\"]+)" $1 | sed "s/data-original=\"//"`

originaldir=`pwd`



pushd /tmp
now=`date +%s`
destdir=emote-$now
destfile=slack_emoticons_$now.tar.gz
mkdir $destdir


for url in $urls
do
  name=`echo $url | sed "s/^https:\/\/emoji.slack-edge.com\/[^\/]*\/\([^\/]*\)\/.*/\1/"`
  filename=`echo $url | sed "s/.*\/\([^\/]*\)\.[a-z]*$/\1/"`
  extension=`echo $url | sed "s/.*\.\([^.]*\)$/\1/"`
  echo Getting $name from $url
  wget -q -O $destdir/${name}_${filename}.$extension $url
  tar -czf $destfile $destdir
  mv $destfile $originaldir
done



popd