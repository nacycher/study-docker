## docker compose语法
将docker run命令中的参数，以yaml文件的形式，进行配置，
实际和docker run命令一样，启动容器

### docker compose -f compose.yaml up -d
- 通过compose文件启动docker容器
- 修改文件后，可以重复执行命令，更新容器

### docker compose -f compose.yaml down -v --rmi all
- --rmi all 删除镜像
- -v 删除数据卷