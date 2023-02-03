# mirai-dockerfile-setup
## 如何使用
* 彩蛋:
    * 本地构建：
> 需要配置okteto cli,参考[oketo cli文档](https://www.okteto.com/docs/cloud/okteto-cli)，然后执行sh
*
    * PR构建：
> 需要改动dockerfile（注意那个COPY应该把整个mcl目录给COPY下来，阿里源镜像下载速度是真的不行），拉下来设为私有，然后pr
## Action 持久化部署:
    URL作为SECRET  NAME设置启动的链接加上:114514，然后开启action（测试）
## 可能的问题：
- mirai-console-loader如何关闭
需要提前安装chat-command，登录QQ，然后给机器人发stop
