## docker compose 安装博客
使用docker compose，批量的管理容器
- 批量上线，下线容器
- 启动、停止、扩容、缩容容器
![](./images/docker-18-01.png)

### 使用docker启动开源博客系统wordpress
- 自定义网络blog
- 启动mysql容器
- 启动wordpress容器

docker run -d -p 3306:3306 \
-e MYSQL_ROOT_PASSWORD=123456 \
-e MYSQL_DATABASE=wordpress \
-v mysql-data:/var/lib/mysql \
-v /app/myconf:/etc/mysql/conf.d \
--restart always --name mysql \
--network blog \
mysql:8.0

docker run -d -p 8080:80 \
-e WORDPRESS_DB_HOST=mysql \
-e WORDPRESS_DB_USER=root \
-e WORDPRESS_DB_PASSWORD=123456 \
-e WORDPRESS_DB_NAME=wordpress \
-v wordpress:/var/www/html \
--restart always --name wordpress-app \
--network blog \
wordpress:latest

![](./images/docker-18-02.png)
