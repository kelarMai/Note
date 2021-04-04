如果用户无法使用 sudo 命令，更改 etc/sudoers 文件，在 root ALL=(ALL) ALL 下添加用户的该属性；

配置网络：
    
    nmcli d //查看网络状态
    sudo vi /etc/sysconfig/network-scripts/ifcfg-ens33  //修改文件
    BOOTPROTO=dhcp  ONBOOT=yes //动态配置
    BOOTPROTO=static    ONBOOT=yes  //静态配置
    systemctl restart network //重启网络服务

安装 ifconfig:
    
    yum install net-tools
    可以使用 ifconfig 或者 ip addr 命令查看本机 ip 地址

使用 vscode 连接

更改源，[参考](https://blog.csdn.net/xiaojin21cen/article/details/84726193)

    mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup // 原文件备份
    curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo //下载源配置文件
    yum clean all //清除系统所有的yum缓存
    yum makecache //生成yum缓存
    

安装 vim

    sudo yum install vim-enhanced
