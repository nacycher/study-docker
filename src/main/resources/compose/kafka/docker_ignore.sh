cat > .dockerignore << EOF
# 排除日志目录（大文件主要来源）
logs/

# 排除临时文件目录
tmp/

# 排除构建脚本（不需要复制到镜像）
build_image.sh

# 排除 Git 缓存（如果有）
.git/

# 排除其他冗余文件
*.log
*.tmp
EOF