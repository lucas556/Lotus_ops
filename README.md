# Lotus 运维

## 常用命令

### 查询类

```
查询 Miner 信息 ：lotus-miner info
查询 Worker 状态 ：lotus-miner sealing workers
查询 任务状态 ： lotus-miner sealing jobs

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
