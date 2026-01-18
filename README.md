# Tarantool runtime (beta)

>[!NOTE]
>На текущий момент запуск приложения через docker находится в бете.

В качестве submodule пример [pro-tnt-bot](https://github.com/TNT-Bots/pro-tnt-bot) вынесен в instances.enabled/bot-instance.

----

**Скрипты**

  - [./bin/build](bin/build) - Сборка образа (image).
  - [./bin/start-dev](bin/start-dev) - Запускает временный контейнер и после завершения удаляет.
  - [./bin/start-container](bin/start-container) - Запускает постоянный контейнер.

----

**Переменные окружения**

>[!NOTE]
>Заполните файл `.env` необходимыми переменными.

  - `BOT_TOKEN` - Токен бота.
  - `BOT_CREATOR_ID` - Идентификатор создателя.
  - `BOT_USERNAME` - Юзернейм бота, без `@`.

----

**Решение проблем**

1. Частые пересборки контейнера
    Ошибка вида:
    ```
    Warning: Failed searching manifest: Failed downloading http://rocks.tarantool.org/manifest - failed downloading http://rocks.tarantool.org/manifest
    ```

    Означает что `rocks.tarantool.org` ограничил вам загрузку с вашего IP. 

    Заработает через несколько часов/дней.
    
    Чтобы не переустанавливать каждый раз пакеты, прокидывайте `.rocks` в контейнер и пользуйтесь проверками вида:
    ```bash
    #!/usr/bin/env bash
    
    ROOT_DIR="$(
      cd "$(dirname "$0")" && pwd
    )"
    
    source "${ROOT_DIR}/tnt-tg-bot/bin/lib/tools.sh"
    
    #
    # Bot rocks
    #
    bash "$ROOT_DIR/tnt-tg-bot/tnt-tg-bot.pre-build.sh"
    
    #
    # App rocks
    #
    # github.com/uriid1/argp
    tools::luarocks_install "argp" "1.1-0"
      ```

**Запуск**

  1. Установить `BOT_TOKEN` в файле `.env`
  2. Рекурсивно загрузить submodules

      ```bash
      git submodule update --init --remote --merge --recursive
      ```
  3. Выполнить сборку образа

      ```bash
      bash scripts/build
      ```
  4. Запустить контейнер

      ```bash
      bash scripts/start-dev
      ```
