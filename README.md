# 极光面板中转机客户端

对于不在中转机器（被控机）支持进度里面的系统版本，无法直接使用面板连接中转机器。 如果被控机支持运行 docker，则可以利用被控机运行一个网络模式为 host 的特权被控端容器，并利用面板连接到被控端容器中，实现各种转发功能。

# 使用教程

请先确保中转机已经安装 Docker 并且 Docker 运行正常。被控端镜像编译后大概占用 250MB 的存储空间。

**注意事项：** 由于需要在容器内运行 systemd 服务，如果被控机主机上已开启 `cgroup v2` 会造成兼容性问题，需要手动把被控机主机上的 `cgroup v2` 先关闭（判断 `cgroup v2` 是否已开启可以在主机上输入 `docker info | grep Cgroup` ，若命令执行结果显示**不为** `Cgroup Driver: cgroupfs; Cgroup Version: 1` 则需要关闭 `cgroup v2` ），可参考以下步骤：

1. 修改 `/etc/default/grub` 文件，添加参数 `GRUB_CMDLINE_LINUX="systemd.unified_cgroup_hierarchy=0"`（如果原本已有 `GRUB_CMDLINE_LINUX` 配置，请将 `systemd.unified_cgroup_hierarchy=0` 添加到原有配置最后）
2. 更新被控主机 `grub` ：`sudo update-grub`
3. 重启被控主机：`sudo reboot`

## 方法一：一键部署被控端容器（简单）

被控端容器默认用户名 root ，密码 AuroraAdminPanel321 （**！请务必手动修改容器默认密码！**），SSH 端口号 62222，连接 ip 同部署在的中转机的 ip 。

```shell
sudo docker pull smartcatboy/aurora-client:latest && \
sudo docker run -d --privileged --name aurora-client --network=host --restart=always -v /lib/modules:/lib/modules smartcatboy/aurora-client:latest
```

## 方法二：手动编译被控端镜像并部署容器

该方法在编译被控端镜像时，可以手动指定 SSH 端口号以及 root 用户密码，可以提高安全性。**由于镜像编译过程中会拉取 centos 官方的 yum 源，请保证编译的时候中转机器国外网络连接正常。**

```shell
# 1. 在中转机下载本仓库
git clone https://github.com/smartcatboy/aurora-client.git
# 2. 编译被控端 Docker 镜像（ SSH_PORT 为连接端口，注意不要设置成与主机 SSH 端口号一致造成冲突，PASSWD 为 root 对应的密码）
cd aurora-client
sudo docker build -f Dockerfile -t aurora-client --build-arg SSH_PORT=62222 --build-arg PASSWD=AuroraAdminPanel321 .
# 3. 启动被控端特权容器，设置网络模式为 host ，并设置为开机自启动
sudo docker run -d --privileged --name aurora-client --network=host --restart=always -v /lib/modules:/lib/modules aurora-client:latest
# 4. 使用面板连接中转机 Docker 被控端（ ip 同中转机 ip，用户名：root，默认端口号：62222，默认密码：AuroraAdminPanel321 ）
```
