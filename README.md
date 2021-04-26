# Lotus 运维

## 常用命令

### 查询类

```
查询 Miner 信息 ：lotus-miner info
查询 Worker 状态 ：lotus-miner sealing workers
查询 任务状态 ： lotus-miner sealing jobs

```

### 操作类

#### 设置 软阵列 Raid0
```
fdisk /dev/sda     // g n 回车 回车 wq
fdisk /dev/sdb     // g n 回车 回车 wq
mkfs.ext4 /dev/sda1
mkfs.ext4 /dev/sdb1
mdadm -C -a yes /dev/md001 -l 0 -n 2 /dev/sd{a,b}1
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
