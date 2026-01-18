FROM tarantool/tarantool:3.6

ENV APP_INSTANCE_SRC="/opt/tarantool/instances.enabled"
ENV INSTANCE_NAME="bot-instance"
ENV BOT_INSTANCE_SRC="/opt/tarantool/instances.enabled/${INSTANCE_NAME}"

RUN set -x \
  # Because their servers are not responding
  && rm /etc/apt/sources.list.d/tarantool.list \
  # Installing tools/libs
  && apt-get update \
  && apt-get install --no-install-recommends --no-install-suggests -y \
    luarocks \
    unzip \
    git \
    make \
    cmake \
    gcc \
    libssl-dev \
    liblua5.1-0-dev \
  #
  # Cleanup
  #
  && apt autoremove -y

WORKDIR ${BOT_INSTANCE_SRC}

COPY entrypoint /usr/local/bin/entrypoint
RUN chmod +x /usr/local/bin/entrypoint

EXPOSE 9091

ENTRYPOINT ["/usr/local/bin/entrypoint"]
