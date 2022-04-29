#!/bin/bash

echo "| P-state | Config | CPU Set | CorWatt | PkgWatt |"
echo "|---------|--------|---------|---------|---------|"

for pstate in "P2" "P1" "P0" "PB"
do
	for config in "1-1-1" "2-1-1" "2-2-1-A" "2-2-1-B" "2-2-1-C" "2-2-1-D" "2-2-1-E" "2-2-1-F" "2-2-2-A" "2-2-2-B" "2-2-2-C" "2-2-2-D" "2-2-2-E" "2-2-2-F" "32-16-4"
	do
		cpuset=`cat $pstate-$config.cpuset`
		corwatt=`cat $pstate-$config.out | sed -n "3p" | cut -d$'\t' -f16`
		pkgwatt=`cat $pstate-$config.out | sed -n "3p" | cut -d$'\t' -f17`
		echo "| $pstate  | $config | $cpuset | $corwatt | $pkgwatt |"
	done
done
