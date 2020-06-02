FROM alpine:latest

ENV TZ=Asia/Shanghai

RUN apk --no-cache --update add bash && \
    mkdir /v2ray && \
    cd /v2ray && \
    wget https://raw.githubusercontent.com/v2ray/dist/master/v2ray-linux-64.zip && \
    unzip v2ray-linux-64.zip && \
    rm v2ray-linux-64.zip && \
    chmod +x v2ray v2ctl && \