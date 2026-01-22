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
-jar /ap-worker.jar \
--spring.cloud.bootstrap.location=/config/bootstrap.yml \
--logging.path=/logs \
> /logs/nohup.out 2>&1

# 4. 打印启动提示（若执行到此处，说明应用启动失败）
echo "应用启动异常，日志路径：/logs/nohup.out"

# 5. 保持Docker容器前台运行（兜底）
tail -f /logs/nohup.out