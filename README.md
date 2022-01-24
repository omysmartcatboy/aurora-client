# 极光面板中转机客户端

对于不在中转机器（被控机）支持进度里面的系统版本，无法直接使用面板连接中转机器。 如果被控机支持运行 docker，则可以利用被控机运行一个网络模式为 host 的特权被控端容器，并利用面板连接到被控端容器中，实现各种转发功能。

# 使用教程

请先确保中转机已经安装 Docker 并且  Docker 运行正常。

```shell
# 1. 在中转机下载本仓库
git clone https://github.com/smartcatboy/aurora-client.git
# 2. 编译被控端 Docker 镜像
cd aurora-client
sudo docker build -f Dockerfile -t aurora-client --build-arg SSH_PORT=62222 --build-arg PASSWD=AuroraAdminPanel321 .
# 3. 启动被控端特权容器，设置网络模式为 host ，并设置为开机自启动
sudo docker run -d --privileged --name aurora-client --network=host --restart=always -v /lib/modules:/lib/modules aurora-client:latest
# 4. 使用面板连接中转机 Docker 被控端（ ip 同中转机 ip，用户名：root，默认端口号：62222，默认密码：AuroraAdminPanel321 ）
```
