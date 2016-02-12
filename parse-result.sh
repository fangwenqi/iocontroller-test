#!/bin/bash

#1 sh
function parse_one()
{
	echo $1
	cat $1 | grep create_cg
	for t in $(ls log/$1/*.log); do
		aggrb=$(cat $t | grep aggrb | grep aggrb | awk '{print $3}')
		if [ -n $aggrb ]; then
			echo "$t : $aggrb"
		fi
	done
	echo ""
}

for t in $(ls level*); do
	parse_one $t
done
