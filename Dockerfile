FROM alpine

ENV TZ=Asia/Shanghai

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories && \
    apk --no-cache --no-progress upgrade add perl curl bash iptables pcre openssl dnsmasq ipset iproute2 tzdata && \
    sed -i 's/mirrors.aliyun.com/dl-cdn.alpinelinux.org/g' /etc/apk/repositories && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN mkdir -p /v2ray && \
    cd /v2ray && \
    wget https://raw.githubusercontent.com/v2ray/dist/master/v2ray-linux-64.zip && \
    unzip v2ray-linux-64.zip && \
    rm v2ray-linux-64.zip && \
    chmod +x v2ray v2ctl && \
    mkdir -p /sample_config

RUN cd / && mkdir -p /ss-tproxy &&\
    wget https://github.com/zfl9/ss-tproxy/archive/v4.6.zip && \
    unzip -jd ss-tproxy v4.6.zip && \
    rm v3-master.zip && \
    sed -i 's/while umount \/etc\/resolv.conf; do :; done/while mount|grep overlay|grep \/etc\/resolv.conf; do umount \/etc\/resolv.conf; done/g' /ss-tproxy/ss-tproxy && \
    sed -i 's/60053/53/g' /ss-tproxy/ss-tproxy && \
    sed -i '/no-resolv/i\addn-hosts=$dnsmasq_addn_hosts' /ss-tproxy/ss-tproxy && \
    install -c /ss-tproxy/ss-tproxy /usr/local/bin && \
    mkdir -m 0755 -p /etc/ss-tproxy && \
    chown -R root:root /etc/ss-tproxy && \
    install -c /ss-tproxy/ss-tproxy.conf /ss-tproxy/gfwlist.* /ss-tproxy/chnroute.* /etc/ss-tproxy && \
    rm -rf /ss-tproxy

RUN mkdir -p /koolproxy && cd /koolproxy && \
    wget https://raw.githubusercontent.com/user1121114685/koolproxyR/master/koolproxyR/koolproxyR/koolproxy && \
    chmod +x koolproxy && \
    chown -R daemon:daemon /koolproxy

COPY init.sh /
COPY chinadns /tmp/chinadns
COPY ss-tproxy.conf v2ray.conf gfwlist.ext /sample_config/

RUN chmod +x /init.sh && \
	install -c /tmp/chinadns /usr/local/bin && \
	rm -rf /tmp/*

CMD ["/init.sh","daemon"]
