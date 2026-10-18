#!/bin/bash

DATA=$(`dirname $0`/crypto.py 2> /dev/null)

if [ -z "$DATA" ];
then
	echo :\'\(
else
	echo $DATA
fi
