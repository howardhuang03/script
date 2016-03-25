#!/bin/bash
#
# This scritp is a log recorder for HTC MoCap project
# Created by Howard Huang

TIME=`date +"%Y%m%d%H%M"`

MOCAP_LOG_DIR="/home/howard-huang/share/log/mocap-log"
KERNEL_LOG_DIR="$MOCAP_LOG_DIR/kernel"
DEVICE_LOG_DIR="$MOCAP_LOG_DIR/device"

KERNEL_LOG="$KERNEL_LOG_DIR/kernel-$TIME.log"
DEVICE_LOG="$DEVICE_LOG_DIR/device-$TIME.log"


# Show debug parameter
function show_parameter() {
	echo $TIME
	echo $KERNEL_LOG_DIR
	echo $DEVICE_LOG_DIR
	echo $KERNEL_LOG
	echo $DEVICE_LOG
}

# Show help
function show_help() {
	echo "mocap-log.sh -k -s -c [option]"
	echo "-k: kill old log process"
	echo "-s: start log process"
	echo "-c: clean kernel & device logs"
	echo "    [option]: kernel"
	echo "              device"
	echo "              all"
}

function clean_log_file() {
	case $1 in
	kernel)
		echo "Remove kernel log"
		rm -r $KERNEL_LOG_DIR/*
		;;
	device)
		echo "Remove device log"
		rm -r $DEVICE_LOG_DIR/*
		;;
	all)
		echo "Remove device & kernel log"
		rm -r $KERNEL_LOG_DIR/*
		rm -r $DEVICE_LOG_DIR/*
		;;
	esac
}

# Kill the old log record process
function kill_log_process() {
	KERNEL_OLD_PID=`ps aux|grep 'adb shell cat'|grep -v 'grep'|awk '{print $2}'`
	DEVICE_OLD_PID=`ps aux|grep 'adb logcat'|grep -v 'grep'|awk '{print $2}'`

	[ -z $KERNEL_OLD_PID ] || {
		echo "Kill old kernel log process $KERNEL_OLD_PID"
		kill $KERNEL_OLD_PID
	}
	[ -z $DEVICE_OLD_PID ] || {
		echo "Kill old device log process $DEVICE_OLD_PID"
		kill $DEVICE_OLD_PID
	}
}

# Start to Log record
function start_log_process() {
	adb logcat -v time -b main -b system > $DEVICE_LOG &
	adb shell cat /proc/kmsg > $KERNEL_LOG &
	ps aux|grep 'adb'|grep -v 'grep'
}

function main() {

	while getopts :ksc: flag
	do
		case $flag in
		k)
			kill_log_process
			;;
		s)
			kill_log_process
			start_log_process
			;;
		c)
			clean_log_file $OPTARG
			;;
		\?)
            show_help
            exit 0
            ;;
		esac
	done
}

# Start main process
main "$@"

