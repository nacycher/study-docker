#!/bin/sh

# 1. 创建日志目录，确保日志能正常写入
mkdir -p /logs

# 2. 切换到根目录，保证Spring Boot扫描/config目录
cd /

# 3. 核心启动命令（移除后台&，改用前台运行；优化配置路径参数）
java \
-Xms1024m \
-Xmx1536m \
-XX:MetaspaceSize=128M \
-XX:MaxMetaspaceSize=256M \
-jar /xxl-job-admin-2.4.1-SNAPSHOT.jar \
--spring.config.location=/config/application.properties \
--logging.path=/logs \
2>&1 | tee -a /spp/logs/nohup.out

echo "【ERROR】应用启动异常/已退出，日志路径：/spp/logs/nohup.out"
exit 1