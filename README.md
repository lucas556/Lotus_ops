# Lotus 运维

## 常用命令

### 环境变量

```
export LOTUS_PATH="/md0/daemon"
export WORKER_PATH="/md0/worker"
export FIL_PROOFS_PARAMETER_CACHE="/proof"
export IPFS_GATEWAY="https://proof-parameters.s3.cn-south-1.jdcloud-oss.com/ipfs/"

export BELLMAN_CUSTOM_GPU="GeForce RTX 3090:10496, GeForce RTX 3080:8704"

export FIL_PROOFS_MAXIMIZE_CACHING=1
unset USE_EXP_CACHE
export FIL_PROOFS_USE_GPU_COLUMN_BUILDER=1
export FIL_PROOFS_USE_GPU_TREE_BUILDER=1
```
#### supervisorctl worker.conf
```
[program:worker]
command=/md0/worker/run_worker.sh
user=root

autostart=true
autorestart=true
stopwaitsecs=60
startretries=999
stopasgroup=true
killasgroup=true

redirect_stderr=true
stdout_logfile=/md0/worker/worker.log
stdout_logfile_maxbytes=256MB
```

### 查询类

```
查询 Miner 信息 ：lotus-miner info
查询 Worker 状态 ：lotus-miner sealing workers
查询 任务状态 ： lotus-miner sealing jobs

UUID查询: ll -l /dev/disk/by-uuid/ | awk -F ' ' '{print $9}'
```

### 操作类

#### 设置 软阵列 Raid0
```
fdisk /dev/sda     // g n 回车 回车 wq
fdisk /dev/sdb     // g n 回车 回车 wq
mkfs.ext4 /dev/sda1
mkfs.ext4 /dev/sdb1
mdadm -C -a yes /dev/md0 -l 0 -n 2 /dev/sd{a,b}1
mdadm -Ds > /etc/mdadm.conf
```

### 关闭NUMA
Ubuntu18.04 的 grub 文件修改，编辑 /boot/grub/grub.cfg，找到 Linux 引导行，该行类似如下（不同版本内容略有差异，但开头有 linux /boot/vmlinuz-）：
```
linux   /boot/vmlinuz-4.15.0-106-generic root=UUID=2c5f7d8a-ff33-4c78-b5a4-cd8dc75823f3 ro  maybe-ubiquity
```
在Linux引导行的末尾，空格再添加 numa=off .

```
linux   /boot/vmlinuz-4.15.0-147-generic root=UUID=25cacca4-31f7-441e-bb2b-aebe562a9c06 ro numa=off
```

修改后保存，再重启系统，再验证是否成功关闭 NUMA .
```
numastat
```
如果输出结果中只有 node0，则表示成功禁用了NUMA，如果有 node1 出现则失败。

```
root@seal60162:/# numastat
                           node0
numa_hit                18234527
numa_miss                      0
numa_foreign                   0
interleave_hit            156929
local_node              18234484
other_node                     0
```

#### 磁盘开机启动
```
/dev/disk/by-uuid/c4e44938-6c3d-43c9-b8e3-86cf95659a93 /worker ext4 noatime,nofail 0 0
```
### screen

```
screen -S plotman plotman interactive

screen -ls

screen screen -r 2465
```


### 显卡驱动
```
# 卸载显卡驱动
sudo apt-get --purge remove nvidia*
sudo apt autoremove
sudo apt-get --purge remove "*nvidia*"
```

3080:
```
https://cn.download.nvidia.com/XFree86/Linux-x86_64/460.39/NVIDIA-Linux-x86_64-460.39.run
```

## 常见问题处理

```
报错 : lotus-miner: error while loading shared libraries: libhwloc.so.5: cannot open shared object file: No such file or directory
sudo ln -s /usr/lib/x86_64-linux-gnu/libhwloc.so /usr/lib/libhwloc.so.5
```

```
删除ret-wait任务
lotus-miner sealing abort $id
```
