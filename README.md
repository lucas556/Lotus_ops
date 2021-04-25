# Lotus 运维

## 常见问题处理

```
报错 : lotus-miner: error while loading shared libraries: libhwloc.so.5: cannot open shared object file: No such file or directory
sudo ln -s /usr/lib/x86_64-linux-gnu/libhwloc.so /usr/lib/libhwloc.so.5
```

```
删除ret-wait任务
lotus-miner sealing abort $id
```
