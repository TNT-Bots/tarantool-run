FROM tarantool/tarantool:3.6

ENV TNT_TG_BOT_SRC="/usr/local/src/tnt-tg-bot"
ENV BOT_APP_SRC="/usr/local/bot-instance"

RUN set -x && \
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
  # Clone tnt-tg-bot
  #
  git clone \
  --recursive \
  --depth=1 \
  https://github.com/TNT-Bots/tnt-tg-bot "${TNT_TG_BOT_SRC}" && \
  #
  # Copy source
  #
  mkdir -p "${BOT_APP_SRC}" && \
  cp -r "${TNT_TG_BOT_SRC}/bot" "${BOT_APP_SRC}" && \
  cp -r "${TNT_TG_BOT_SRC}/spec" "${BOT_APP_SRC}" && \
  cp "${TNT_TG_BOT_SRC}/config.ld" "${BOT_APP_SRC}" && \
  cp "${TNT_TG_BOT_SRC}/.luacheckrc" "${BOT_APP_SRC}" && \
  #
  # Probably won't need it for a bot
  #
  unset TT_CONFIG && \
  unset TT_INSTANCE_NAME && \
  #
  # Build http lib
  #
  git clone https://github.com/tarantool/http.git && \
  cd http && \
  cmake . -DCMAKE_BUILD_TYPE=RelWithDebugInfo && \
  make && \
  make install && \
  #
  # Decencies tnt-tg-bot install
  # See: https://github.com/TNT-Bots/tnt-tg-bot/blob/master/tnt-tg-bot.pre-build.sh
  #
  cd ${BOT_APP_SRC} && \
  luarocks install --local --tree=$PWD/.rocks --lua-version 5.1 lua-multipart-post && \
  luarocks install --local --tree=$PWD/.rocks --lua-version 5.1 pimp && \
  CC="gcc -std=gnu99" luarocks install --local --tree=$PWD/.rocks --lua-version 5.1 luaossl

WORKDIR ${BOT_APP_SRC}

EXPOSE 9091

CMD ["tarantool", "/usr/local/bot-instance/app.lua"]
