#!/bin/bash
source util.sh

init_cgroup

create_cg level1a 200
create_cg level1b 800
create_cg level1c 200

cleanup()
{
	killall -9 fio
	rm_cg level1a
	rm_cg level1b
	rm_cg level1c
}

trap cleanup SIGHUP SIGINT SIGTERM
LOGDIR=log/$0
mkdir $LOGDIR
iostat -x -k -p $DISK 1 > $LOGDIR/log &

run_4k_rread level1a > $LOGDIR/1a.log
run_4k_rwrite level1b > $LOGDIR/1b.log
run_4k_rread level1c > $LOGDIR/1c.log

sleep 120
killall iostat

wait
cleanup
