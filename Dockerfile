FROM alpine:latest

LABEL maintainer="cernoel"
LABEL name="cernoel/bludit-docker"

RUN addgroup -g 555 -S nginx \
    && adduser -SD -u 555 -h /usr/share/nginx -s /sbin/nologin -G nginx -g nginx nginx \
    && apk --no-cache add curl \
         ruby \
         ruby-json \
         jq \
         nginx \
         php8 \
         php8-fpm \
         php8-curl \
         php8-dom \
         php8-gd \
         php8-json \
         php8-mbstring \
         php8-openssl \
         php8-session \
    && mkdir -p /bludit /usr/share/nginx/html

RUN BLUDIT_VERSION=$(curl -sq https://api.github.com/repos/bludit/bludit/releases/latest | jq -r '.tag_name') \
    && curl -L --output /tmp/bludit-v${BLUDIT_VERSION}.tar.gz https://api.github.com/repos/bludit/bludit/tarball/${BLUDIT_VERSION} \
    && tar -C /bludit \
      --strip-components=1 \
      --exclude='*/.gitignore' \
      --exclude='*/.github' \
      --exclude='*/README.md' \
      --exclude='*/LICENSE' -xvf /tmp/bludit-v${BLUDIT_VERSION}.tar.gz \
    && chown -R nginx:nginx /bludit \
    && rm -rf /etc/nginx/conf.d && mkdir /etc/nginx/conf.d

COPY root/ /

WORKDIR /usr/share/nginx/html

EXPOSE 8080

CMD ["/docker-init.sh"]
