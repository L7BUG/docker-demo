#!/bin/bash

# 检查是否有足够的输入参数
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <service_name> <docker_ip_port>"
    echo "Example: $0 service_name 127.0.0.1:8081"
    exit 1
fi

# 获取服务名称和 Docker 端口
SERVICE_NAME=$1
DOCKER_PORT=$2

# 配置文件路径
NGINX_ENABLED_DIR="/etc/nginx/sites-enabled"
CONF_FILE="$(pwd)/docker.local.${SERVICE_NAME}.conf"

# 生成 Nginx 配置内容
cat > "$CONF_FILE" <<EOF
server {
    listen 80;
    server_name docker.local;  # 绑定到 docker.local 域名

    location /${SERVICE_NAME} {
        proxy_pass http://${DOCKER_PORT};  # 将请求转发到 Docker 容器
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF

# 创建符号链接到 sites-enabled 目录
sudo ln -sf "$CONF_FILE" "$NGINX_ENABLED_DIR/$(basename "$CONF_FILE")"

# 检查 Nginx 配置文件的有效性
sudo nginx -t

# 如果没有错误，重载 Nginx 配置
if [ $? -eq 0 ]; then
    echo "Nginx configuration for ${SERVICE_NAME} is valid. Reloading Nginx..."
    sudo systemctl reload nginx
else
    echo "Nginx configuration error. Please fix it and try again."
    exit 1
fi

echo "Nginx configuration for ${SERVICE_NAME} has been added successfully!"
