# 更新源
  echo "更新源开始"
  sudo mv /etc/apt/sources.list /etc/apt/sources.list.bak
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

#----------------------设置DNS-------------------------------
echo "nameserver 119.29.29.29" >> /etc/resolv.conf
echo "nameserver 180.76.76.76" >> /etc/resolv.conf

apt-get update

# sudo apt-get install python3.7-venv python3.7-distutils python3.7-dev git lsb-release -y
sudo apt install -y git wget cpufrequtils sysfsutils ntpdate

# -----------------------------时钟校验------------------------------------------------
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
ntpdate ntp.aliyun.com
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
#----------------------------------------------------------------------------------------

cd /
wget https://lotus-1257859707.cos.ap-beijing.myqcloud.com/chia-blockchain.tar.gz
mkdir -p /chia-blockchain
tar zxvf chia-blockchain.tar.gz

cd /chia-blockchain

mkdir -p ～/.pip
  cat > ～/.pip/pip.conf << EOF
[global]
index-url = https://pypi.tuna.tsinghua.edu.cn/simple
[install]
trusted-host = pypi.tuna.tsinghua.edu.cn
EOF

sh install.sh

. ./activate

chia init

pip install --force-reinstall git+https://github.com/ericaltendorf/plotman@main
plotman config generate

rm -rf /root/.config/plotman/plotman.yaml
cd /root/.config/plotman/ && wget https://lotus-1257859707.cos.ap-beijing.myqcloud.com/plotman.yaml

mkdir -p /home/chia/logs
# plotman interactive
