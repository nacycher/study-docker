# 先清理旧容器
docker stop kafka && docker rm kafka

docker run --name kafka \
--network netkafka \
-p 9092:9092 -p 9093:9093 -p 9094:9094 \
-e KAFKA_CFG_NODE_ID=0 \
-e KAFKA_CFG_PROCESS_ROLES=broker,controller \
-e KAFKA_CFG_CONTROLLER_QUORUM_VOTERS=0@localhost:9093 \
-e KAFKA_CFG_ADVERTISED_LISTENERS=PLAINTEXT://172.26.122.77:9092 \
-e KAFKA_CFG_LISTENERS=PLAINTEXT://0.0.0.0:9092,CONTROLLER://0.0.0.0:9093 \
-e KAFKA_CFG_LISTENER_SECURITY_PROTOCOL_MAP=PLAINTEXT:PLAINTEXT,CONTROLLER:PLAINTEXT \
-e KAFKA_CFG_CONTROLLER_LISTENER_NAMES=CONTROLLER \
-e ALLOW_PLAINTEXT_LISTENER=yes \
-e KAFKA_KRAFT_CLUSTER_ID=abcdefghijklmnopqrstuv \
--user root \
-v /tmp/frod/spp/kafka-data:/bitnami/kafka/data \
-d bitnami/kafka:3.6.2

docker run --name kafka-ui \
--network netkafka \
-p 8099:8080 \
-e KAFKA_CLUSTERS_0_NAME=Local-Kafka \
-e KAFKA_CLUSTERS_0_BOOTSTRAPSERVERS=kafka:9092 \
-e KAFKA_CLUSTERS_0_ALLOW_PLAINTEXT=true \
-d \
provectuslabs/kafka-ui

docker run -d \
  --network  netkafka \
  --name mongo \
  -p 172.26.122.77:27017:27017 \
  -v /data/mongo/db:/data/db \
  --restart always \
  -e MONGO_INITDB_ROOT_USERNAME=root \
  -e MONGO_INITDB_ROOT_PASSWORD=1qaz2WSX \
  mongo:4.0.5

docker run -d  --name spp-actuator --network netkafka  -p 18093:18093 spp/actuator:20260121v1
docker run -d  --name spp-ap-worker --network netkafka -p 10006:10006 spp/ap-worker:20260121v1
docker run -d  --name spp-kafka --network netkafka -p 18086:18086 spp/kafka:20260121v1
docker run -d  --name spp-admin --network netkafka  -p 10003:10003  spp/spp-admin:20260121v1
docker run -d  --name spp-xxljob --network netkafka -p 8081:8081 spp/xxl-job-admin:20260121v1
docker run -d  --name spp-python --network netkafka -v spp-algorithm-volume:/spp/algorithm/ spp/python:20260121v1

docker run -d  --name report-service -p 9999:9999 -v /data/ford_app/temp/mysql/report/:/report/upload/ report-service:20260130v1


docker volume create \
--name spp-algorithm-volume \
--opt type=none \
--opt device=/tmp/frod/spp/python/algorithm \
--opt o=bind

docker exec -it spp-actuator /bin/bash
docker exec -it spp-ap-worker tail-f /logs/nohup.out


linuxscp:
  host: 172.26.122.77
  username: sppadmin
  password: Spp@123456
  port: 22
  local: /u01/spp/spp-ebiz/spp-admin/file/strategyFile/*
  remote: /u01/spp/spp-ebiz/spp-admin/file/strategyFile
  local-report: /u01/spp/spp-ebiz/spp-admin/reportForms
  remote-report: /u01/spp/spp-ebiz/spp-admin/reportForms


python3.7 -m pip freeze > requirements.txt
# 重新完整下载所有依赖的纯二进制包，无任何源码包
PIP_INSECURE=1 python3.7 -m pip download -r requirements.txt -d ./pip_packages \
  --only-binary=:all: \
  -i http://mirrors.aliyun.com/pypi/simple/ \
  --trusted-host mirrors.aliyun.com
# 必做：将requirements.txt拷贝到包目录
cp requirements.txt ./pip_packages/