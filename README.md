# mirai-dockerfile-setup
## 如何使用
* 本地方式（默认：stable）:你只需要clone本项目，将自己的机器人文件（bots和插件plugins）放在同目录下然后执行
```docker bulid -t mcl:latest .```
就打包好了
## 可能的问题：
- mirai-console-loader如何关闭
需要提前安装chat-command，登录QQ，然后给机器人发stop，但是注意docker并不会关闭
> 彩蛋：可以去另一个分支看一眼
