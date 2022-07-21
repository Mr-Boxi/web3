# 构建docker容器
# 基础镜像
FROM nginx
# 容器中的工作目录
WORKDIR /usr/share/nginx/html
# 将当前的_book路径拷贝到容器的工作目录
ADD ./_book .
# 暴露端口方便映射
EXPOSE 80