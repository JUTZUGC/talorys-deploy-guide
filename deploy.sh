#!/usr/bin/env bash
set -euo pipefail
# Talorys 一键部署脚本（第三方指南）——按官方文档封装
# 官方文档：https://github.com/rociiu/talorys#4-deploy
# 更新日期：2026-10-30
# 类型：script
cd "$(dirname "${BASH_SOURCE[0]}")"

command -v git >/dev/null 2>&1 || { echo "需要先安装 Git"; exit 1; }
command -v node >/dev/null 2>&1 || { echo "需要先安装 Node.js"; exit 1; }

mkdir -p .download
cd .download

node -e "console.log('Node', process.version)"
npx create-talorys@latest
echo "按安装器提示在浏览器完成 Cloudflare 授权，记下输出的 pages.dev 地址"

echo ""

echo "部署完成：打开安装器给出的 *.pages.dev 地址，用安装时设的 owner 密码登录；想换模型或开语义记忆到 Settings 里调"
echo "若结果异常或需要改配置，请参考官方文档：https://github.com/rociiu/talorys#4-deploy"
