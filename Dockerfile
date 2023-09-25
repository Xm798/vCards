FROM node:18-alpine

WORKDIR /app/

RUN apk add --no-cache radicale git && \
  rm -rf /var/cache/apk/* && \
  git clone https://github.com/Xm798/vCards/ && \
  cd vCards && \
  yarn && \
  yarn radicale

WORKDIR /app/

RUN { \
  echo '[root]'; \
  echo 'user: .+'; \
  echo 'collection:'; \
  echo 'permissions: R'; \
  echo; \
  echo '[principal]'; \
  echo 'user: .+'; \
  echo 'collection: {user}'; \
  echo 'permissions: R'; \
  echo; \
  echo '[collections]'; \
  echo 'user: .+'; \
  echo 'collection: {user}/[^/]+'; \
  echo 'permissions: rR'; \
  } > /etc/radicale/rights \
  \
  && { \
  echo '[server]'; \
  echo 'hosts = 0.0.0.0:5232, [::]:5232'; \
  echo; \
  echo '[web]'; \
  echo 'type = none'; \
  echo; \
  echo '[storage]'; \
  echo 'type = multifilesystem'; \
  echo 'filesystem_folder = /app/radicale'; \
  echo; \
  echo '[rights]'; \
  echo 'type = from_file'; \
  echo 'file = /etc/radicale/rights'; \
  } > /etc/radicale/config

RUN mkdir -p /app/radicale/collection-root/cn/ && \
  cp -rf /app/vCards/radicale/ /app/radicale/collection-root/cn/

EXPOSE 5232

CMD ["radicale"]