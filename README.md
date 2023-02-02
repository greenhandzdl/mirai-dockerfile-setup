# mirai-dockerfile-setup
## 如何使用
* 本地方式:你只需要clone本项目，将自己的机器人文件（bots和插件plugins）放在同目录下然后执行
```docker bulid -t mcl:latest .```
* 白嫖推荐：需要改动dockerfile，标注的COPY部分将无效，参考[oketo cli文档](https://www.okteto.com/docs/cloud/okteto-cli)
## 可能的问题：
- mirai-console-loader如何关闭
登录QQ，然后给机器人发stop
