#!/bin/bash

CGROUP_DIR=/sys/fs/cgroup
export DISK=sdb

#$1 disk name
function get_disk_devt()
{
	str=$(ls /dev/$1 -l | awk '{print $5, $6}' | awk -F',' '{print $1, $2}'|awk '{printf("%s:%s", $1,$2);}')
	echo $str
}

function init_cgroup() {
	if [ ! -e $CGROUP_DIR/cgroup.subtree_control ]; then
		echo 'noop' > /sys/block/$DISK/queue/scheduler
		mount -t cgroup2 none $CGROUP_DIR
		echo "+io" > $CGROUP_DIR/cgroup.subtree_control
		echo "$(get_disk_devt $DISK) weight_bw" > $CGROUP_DIR/io.throttle.mode_device
	fi
}

function create_cg()
{
	mkdir $CGROUP_DIR/$1
	echo "+io" > $(dirname $CGROUP_DIR/$1)/cgroup.subtree_control
	echo "$(get_disk_devt $DISK) $2" > $CGROUP_DIR/$1/io.throttle.weight
}

function rm_cg()
{
	rmdir $CGROUP_DIR/$1
}

function __run_cmd()
{
	dir="$CGROUP_DIR/$1"
	(
		echo $BASHPID > $dir/cgroup.procs
		fio $2
	)&
}

function run_cmd()
{
	__run_cmd "$@"
}

function run_4k_rread()
{
	run_cmd $1 "--name=test --ioengine=libaio --direct=1 --readwrite=randread --runtime=120 --time_based=1 --filename=/dev/${DISK} --bs=4k --numjobs=8"
}

function run_4k_rwrite()
{
	run_cmd $1 "--name=test --ioengine=libaio --direct=1 --readwrite=randwrite --runtime=120 --time_based=1 --filename=/dev/${DISK} --bs=4k --numjobs=8"
}

function run_4k_rread_ratelimit()
{
	run_cmd $1 "--name=test --ioengine=libaio --direct=1 --readwrite=randread --runtime=120 --time_based=1 --filename=/dev/${DISK} --bs=4k --rate=2M/s"
}

function run_4k_rwrite_ratelimit()
{
	run_cmd $1 "--name=test --ioengine=libaio --direct=1 --readwrite=randwrite --runtime=120 --time_based=1 --filename=/dev/${DISK} --bs=4k --rate=2M/s"
}
