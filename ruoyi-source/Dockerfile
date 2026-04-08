# ========== 第一阶段：使用 Maven 17 镜像编译打包 ==========
# 架构师指定：换用支持 Java 17 的 Maven 编译环境
FROM maven:3.9-eclipse-temurin-17 AS builder
WORKDIR /build

COPY . .
RUN mvn clean package -DskipTests

# ========== 第二阶段：使用轻量级 JRE 17 运行程序 ==========
# 架构师指定：换用支持 Java 17 的轻量级运行环境
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app

RUN apk add --no-cache tzdata \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone

COPY --from=builder /build/ruoyi-admin/target/ruoyi-admin.jar ./ruoyi-admin.jar

EXPOSE 8080

CMD ["java", "-Xms256m", "-Xmx512m", "-jar", "ruoyi-admin.jar"]