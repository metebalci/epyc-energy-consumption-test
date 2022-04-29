#!/bin/bash

interval=1
timeout=30

setf() {
	cpupower frequency-set -f $1MHz > /dev/null
}

set_boost() {
	echo $1 > /sys/devices/system/cpu/cpufreq/boost
}

run_test() {
	pstate=$1
	config=$2
	echo "test run: $pstate $config"

	echo 3 > /proc/sys/vm/drop_caches
	sleep 1

	cpupower frequency-set -g userspace > /dev/null

	case "$pstate" in 
		"P2") 
			set_boost 0
			setf 1500
			;;
		"P1")
			set_boost 0
			setf 2200
			;;
		"P0")
			set_boost 0
			setf 3000
			;;
		"PB")	
			set_boost 1
			setf 3000
			;;
		*)
			echo "invalid P-state: $pstate"
			exit 1
	esac

	case "$config" in
		"1-1-1")
			cpuset="12"
			numcpu=1
			;;
		"2-1-1")
			cpuset="12,28"
			numcpu=2
			;;
		"2-2-1-A")
			cpuset="12,13"
			numcpu=2
			;;
		"2-2-1-B")
			cpuset="12,14"
			numcpu=2
			;;
		"2-2-1-C") 
			cpuset="12,15"
			numcpu=2
			;;
		"2-2-1-D")
			cpuset="13,14"
			numcpu=2
			;;
		"2-2-1-E")
			cpuset="13,15"
			numcpu=2
			;;
		"2-2-1-F")
			cpuset="14,15"
			numcpu=2
			;;
		"2-2-2-A")
			cpuset="3,7"
			numcpu=2
			;;
		"2-2-2-B")
			cpuset="3,11"
			numcpu=2
			;;
		"2-2-2-C")
			cpuset="3,15"
			numcpu=2
			;;
		"2-2-2-D")
			cpuset="7,11"
			numcpu=2
			;;
		"2-2-2-E")
			cpuset="7,15"
			numcpu=2
			;;
		"2-2-2-F") 
			cpuset="11,15"
			numcpu=2
			;;
		"32-16-4")
			cpuset="0-31"
			numcpu=32
			;;
		*)
			echo "invalid config: $config"
			exit 1
	esac

	echo $cpuset > $pstate-$config.cpuset

	cpupower frequency-info > $config.info

	turbostat -q --interval $interval -out $pstate-$config.out taskset -c $cpuset stress --cpu $numcpu --timeout $timeout
}	

echo 0 > /proc/sys/kernel/numa_balancing
echo 0 > /proc/sys/kernel/randomize_va_space
swapoff -a

for pstate in "P2" "P1" "P0" "PB"
do
	for config in "1-1-1" "2-1-1" "2-2-1-A" "2-2-1-B" "2-2-1-C" "2-2-1-D" "2-2-1-E" "2-2-1-F" "2-2-2-A" "2-2-2-B" "2-2-2-C" "2-2-2-D" "2-2-2-E" "2-2-2-F" "32-16-4"
	do
		run_test $pstate $config
		sleep 2
	done
done
