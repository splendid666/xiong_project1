# 使用基础镜像
FROM ubuntu:22.04

# 创建目标目录
RUN mkdir -p /app

COPY ./files /app/

# 设置工作目录
WORKDIR /app

# 运行命令（可选）
#CMD ["python", "app.py"]
