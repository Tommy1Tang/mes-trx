#!/bin/bash
# AI Harness Skill: 终极原子化代码生成与物理清洗
TABLE_NAME=$1
if [ -z "$TABLE_NAME" ]; then
  echo "Error: 必须提供表名！"
  exit 1
fi
echo "[System Check] 探测本地环境..."
if [ ! -d "./ruoyi-admin" ]; then
  echo "Error: 未检测到 RuoYi 目录，请在项目根目录执行！"
  exit 1
fi
if [ "$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/)" == "000" ]; then
  echo "Error: RuoYi 后端未启动 (8080端口不通)！请启动后再试。"
  exit 1
fi
echo "[Skill] 呼叫后端 API，目标表：$TABLE_NAME ..."
# 替换为实际 API 地址
curl -X POST "http://localhost:8080/api/tool/agent-gen" \
     -H "Content-Type: application/json" \
     -d "{\"tableName\": \"$TABLE_NAME\"}" \
     --output temp_code.zip
if [ ! -s temp_code.zip ]; then
  echo "Error: ZIP 下载失败！"
  exit 1
fi
echo "[Skill] 解压代码并覆盖 src 目录..."
unzip -q -o temp_code.zip -d ./ruoyi-ui/src/
unzip -q -o temp_code.zip -d ./ruoyi-admin/src/
rm temp_code.zip
echo "[Skill] 执行前端 ESLint 自动修复..."
cd ruoyi-ui && npm run lint --fix --silent && cd ..
echo "[Skill Executing Complete] 基础设施已就位！"
