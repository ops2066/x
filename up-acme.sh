#!/bin/bash

set -e

# 交互式输入域名和邮箱
read -p "请输入你的主域名（例如 example.com）: " DOMAIN
read -p "请输入你的邮箱地址（用于 Let's Encrypt 账户）: " EMAIL

WILDCARD="*.$DOMAIN"
CERT_HOME="/etc/ssl/$DOMAIN"

# 安装 acme.sh（如果尚未安装）
if ! command -v acme.sh &> /dev/null; then
  echo "正在安装 acme.sh..."
  curl https://get.acme.sh | sh
  export PATH="$HOME/.acme.sh:$PATH"
else
  echo "acme.sh 已安装，跳过安装步骤"
fi

# 确保路径包含 acme.sh 目录
export PATH="$HOME/.acme.sh:$PATH"

# 设置默认 CA
acme.sh --set-default-ca --server letsencrypt

# 注册账户（如果尚未注册）
acme.sh --register-account -m "$EMAIL"

# 发起证书申请，手动 DNS 验证方式
acme.sh --issue --dns -d "$DOMAIN" -d "$WILDCARD" \
  --yes-I-know-dns-manual-mode-enough-go-ahead-please --debug

echo
echo "🔔 请登录你的 DNS 服务商，在以下记录中添加 TXT 解析："
echo "    主机记录: _acme-challenge.$DOMAIN"
echo "    类型:     TXT"
echo "    值:       （上面 acme.sh 输出内容中提供的值）"
echo
read -p "按回车键继续验证 DNS 记录是否生效："

# 尝试续期验证
acme.sh --renew -d "$DOMAIN" \
  --yes-I-know-dns-manual-mode-enough-go-ahead-please --debug

# 安装证书到指定目录
mkdir -p "$CERT_HOME"
acme.sh --install-cert -d "$DOMAIN" \
  --key-file       "$CERT_HOME/privkey.pem" \
  --fullchain-file "$CERT_HOME/fullchain.pem" \
  --reloadcmd     "echo '[可选] 重启 nginx 或其他服务命令'"

echo
echo "✅ 泛域名证书申请和安装完成！"
echo "🔒 证书文件路径：$CERT_HOME"
