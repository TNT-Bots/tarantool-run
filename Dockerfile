FROM tarantool/tarantool:3.6

ENV APP_INSTANCE_SRC="/opt/tarantool/instances.enabled"
ENV INSTANCE_NAME="bot-instance"
ENV BOT_INSTANCE_SRC="/opt/tarantool/instances.enabled/${INSTANCE_NAME}"

RUN \
  # Because their servers are not responding
  rm /etc/apt/sources.list.d/tarantool.list && \
  # Installing tools/libs
  apt-get update && \
  apt-get install --no-install-recommends --no-install-suggests -y \
  luarocks \
  unzip \
  git \
  make \
  cmake \
  gcc \
  libssl-dev \
  liblua5.1-0-dev && \
  #
  # Cleanup
  #
  apt autoremove -y

WORKDIR ${BOT_INSTANCE_SRC}

EXPOSE 9091

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]