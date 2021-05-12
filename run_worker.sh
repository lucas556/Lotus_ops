#!/bin/bash
set -e

sleep 10

export RUST_LOG=Trace

echo 53687091200 | sudo tee /proc/sys/vm/dirty_bytes
echo 10737418240 | sudo tee /proc/sys/vm/dirty_background_bytes
echo 1000 | sudo tee /proc/sys/vm/vfs_cache_pressure
echo 100 | sudo tee /proc/sys/vm/dirty_writeback_centisecs
echo 100 | sudo tee /proc/sys/vm/dirty_expire_centisecs
echo 100 | sudo tee /proc/sys/vm/watermark_scale_factor

export WORKER_PATH="/lotusworker"
export FIL_PROOFS_PARAMETER_CACHE="/proof"

export MINER_API_INFO=

export IPFS_GATEWAY="https://proof-parameters.s3.cn-south-1.jdcloud-oss.com/ipfs/"

export BELLMAN_CUSTOM_GPU="GeForce RTX 3090:10496, GeForce RTX 3080:8704"

export FIL_PROOFS_MAXIMIZE_CACHING=1
unset USE_EXP_CACHE
export FIL_PROOFS_USE_GPU_COLUMN_BUILDER=1
export FIL_PROOFS_USE_GPU_TREE_BUILDER=1

export FIL_PROOFS_USE_MULTICORE_SDR=1
export FIL_PROOFS_MULTICORE_SDR_PRODUCERS=1

export FIL_PROOFS_SDR_PARENTS_CACHE_SIZE=1073741824

ip=$(ip addr | awk '/^[0-9]+: / {}; /inet.*global/ {print gensub(/(.*)\/(.*)/, "\\1", "g", $2)}')
port=$(ip addr | awk '/^[0-9]+: / {}; /inet.*global/ {print gensub(/(.*)\/(.*)/, "\\1", "g", $2)}' | cut -d . -f3-4 | sed 's/\.//g')

/lotus/lotus-worker run --listen $ip:$port &
sudo prlimit --nofile=1048576 --nproc=unlimited --rtprio=99 --nice=-19 --pid $!

wait
