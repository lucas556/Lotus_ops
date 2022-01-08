#!/bin/bash

mv /etc/apt/sources.list /etc/apt/sourses.list.backup
# 判断系统版本
release=`lsb_release -r --short`
if [ release -eq '18.04' ] ; then
    cat > /etc/apt/sources.list << EOF
##阿里源 18.04
deb http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse
EOF

elif [ release -eq '20.04' ] ; then
    cat > /etc/apt/sources.list << EOF
##阿里源 20.04
deb http://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ focal-proposed main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ focal-proposed main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse
EOF
fi

#----------------------设置DNS-------------------------------
echo "nameserver 119.29.29.29" >> /etc/resolv.conf
echo "nameserver 180.76.76.76" >> /etc/resolv.conf

apt-get update

# 安装依赖
# sudo apt install -y make pkg-config mesa-opencl-icd ocl-icd-opencl-dev libclang-dev libhwloc-dev hwloc gcc numactl git bzr jq tree openssh-server python3 cpufrequtils sysfsutils supervisor ntpdate nfs-common
apt install -y mesa-opencl-icd ocl-icd-opencl-dev ntpdate ubuntu-drivers-common gcc git bzr jq pkg-config curl clang build-essential hwloc libhwloc-dev wget
apt install -y libclang-dev libhwloc-dev hwloc gcc numactl make pkg-config cpufrequtils sysfsutils supervisor ntpdate nfs-common

# -----------------------------时钟校验------------------------------------------------
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
ntpdate ntp.aliyun.com
# -----------------------------时钟校验结束------------------------------------------------

#----------------------------禁用nouveau---------------------------------
echo "blacklist nouveau" >> /etc/modprobe.d/blacklist_nouveau.conf
echo "options nouveau modeset=0" >> /etc/modprobe.d/blacklist_nouveau.conf
sudo update-initramfs -u

# -----------------------------CPU性能模式------------------------------------------------
sudo cpufreq-set -g performance     # 重启后无效;必须安装cpufrequtils
echo "devices/system/cpu/cpu0/cpufreq/scaling_governor = performance" >> /etc/sysfs.conf  # 永久;必须安装sysfsutils

# 设置 ulimit
ulimit -n 1048576
sed -i "/nofile/d" /etc/security/limits.conf
echo "* hard nofile 1048576" >> /etc/security/limits.conf
echo "* soft nofile 1048576" >> /etc/security/limits.conf
echo "root hard nofile 1048576" >> /etc/security/limits.conf
echo "root soft nofile 1048576" >> /etc/security/limits.conf

#-----------------------------swappiness=1-----------------------------------------------------------------
sysctl vm.swappiness=1
sed -i "/swappiness/d" /etc/sysctl.conf
echo "vm.swappiness=1" >> /etc/sysctl.conf

# ----------------------------设置VM--------------------------------------------------
sysctl vm.dirty_bytes=53687091200
sed -i "/dirty_bytes/d" /etc/sysctl.conf
echo "vm.dirty_bytes=53687091200" >> /etc/sysctl.conf

sysctl vm.dirty_background_bytes=10737418240
sed -i "/dirty_background_bytes/d" /etc/sysctl.conf
echo "vm.dirty_background_bytes=10737418240" >> /etc/sysctl.conf

sysctl vm.vfs_cache_pressure=1000
sed -i "/vfs_cache_pressure/d" /etc/sysctl.conf
echo "vm.vfs_cache_pressure=1000" >> /etc/sysctl.conf

sysctl vm.dirty_writeback_centisecs=100
sed -i "/dirty_writeback_centisecs/d" /etc/sysctl.conf
echo "vm.dirty_writeback_centisecs=100" >> /etc/sysctl.conf

sysctl vm.dirty_expire_centisecs=100
sed -i "/dirty_expire_centisecs/d" /etc/sysctl.conf
echo "vm.dirty_expire_centisecs=100" >> /etc/sysctl.conf


# ----------------------------设置VM结束--------------------------------------------------
