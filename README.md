each cgroup does 4k random read/write workload with iodetph 8

virtual machine: each cgroup can do ~ 12M/s read or write. max bandwidth (2
cgroups) is ~12M/s

a SATA SSD: each cgroup can do ~150M/s read or ~100M/s write. max bandwidth (2
cgroups) is ~270M/s for read and ~170M/s for write.

a very fast NVMe: each cgroup can do ~1700M/s read and ~1400M/s write. max
bandwidth (2 cgroups) is around ~3000M/s for read and ~2800M/s for write.

\*.sh: test script

\*-log: fio/iostat log

\*-log.result: result summary
