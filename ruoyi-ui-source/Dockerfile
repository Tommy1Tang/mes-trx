# ========== 第一阶段：使用 Node 镜像编译打包 ==========
FROM node:18-alpine AS builder
WORKDIR /build

# 先复制 package.json，利用 Docker 缓存加速依赖下载
COPY package.json .

# 设置淘宝镜像源，极速下载依赖
RUN npm config set registry https://registry.npmmirror.com && npm install

# 复制全部前端源码并打包
COPY . .
RUN npm run build:prod

# ========== 第二阶段：使用 Nginx 运行静态网页 ==========
FROM nginx:alpine

# 把第一阶段打包生成的 dist 文件夹，扔进 Nginx 默认的网页目录
COPY --from=builder /build/dist /usr/share/nginx/html

# 暴露内部端口 80
EXPOSE 80

# 以前台守护进程模式启动 Nginx
CMD ["nginx", "-g", "daemon off;"]