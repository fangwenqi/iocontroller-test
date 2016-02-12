#!/bin/bash
source util.sh

init_cgroup

create_cg level1a 200
create_cg level1a/l21a 200
create_cg level1a/l21b 800
create_cg level1a/l21c 800
create_cg level1b 200
create_cg level1b/l21a 200

cleanup()
{
	killall -9 fio
	rm_cg level1a/l21a
	rm_cg level1a/l21b
	rm_cg level1a/l21c
	rm_cg level1a
	rm_cg level1b/l21a
	rm_cg level1b
}

trap cleanup SIGHUP SIGINT SIGTERM
LOGDIR=log/$0
mkdir $LOGDIR
iostat -x -k -p $DISK 1 > $LOGDIR/log &

run_4k_rread level1a/l21a > $LOGDIR/1a.log
run_4k_rwrite level1a/l21b > $LOGDIR/1b.log
run_4k_rread_ratelimit level1b/l21a > $LOGDIR/1ba.log
run_4k_rread level1a/l21c > $LOGDIR/1c.log

sleep 120
killall iostat

wait
cleanup
