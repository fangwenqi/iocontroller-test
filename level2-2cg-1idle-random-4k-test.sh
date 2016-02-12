#!/bin/bash
source util.sh

init_cgroup

create_cg level1a 200
create_cg level1a/l2 200
create_cg level1b 800
create_cg level1b/l2 200

cleanup()
{
	killall -9 fio
	rm_cg level1a/l2
	rm_cg level1a
	rm_cg level1b/l2
	rm_cg level1b
}

trap cleanup SIGHUP SIGINT SIGTERM
LOGDIR=log/$0
mkdir $LOGDIR
iostat -x -k -p $DISK 1 > $LOGDIR/log &

run_4k_rread level1a/l2 > $LOGDIR/1a.log
run_4k_rwrite_ratelimit level1b/l2 > $LOGDIR/1b.log

sleep 120
killall iostat

wait
cleanup
