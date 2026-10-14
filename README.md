# Moon-Userbot-Docker

Automated Docker builds of Moon-Userbot with support for arm64 and including more dependencies.

This image get's build from the latest release daily.

> [!IMPORTANT]  
> The version of this repository you are seeing is likely a mirror.
>
> If you want to contribute any changes please head over to [git.watn3y.de](https://git.watn3y.de/watn3y/Moon-Userbot-Docker) and register an account.

## Why this exists

The official [qbtaumai/moonuserbot](https://hub.docker.com/r/qbtaumai/moonuserbot) image only gets built for amd64. Furthermore it doesn't include dependencies for modules I use. Specifically the [ytdl module](https://github.com/The-MoonTg-project/custom_modules/blob/main/dl/ytdl.py).

## Running with Docker Compose

The Docker image is available on these registries.

- [git.watn3y.de](https://git.watn3y.de/watn3y/-/packages/container/moonuserbot/versions)
- [Docker Hub](https://hub.docker.com/r/watn3y/moonuserbot)

Example compose file:

```yaml
services:
  Moon-Userbot:
    image: watn3y/moonuserbot:latest
    container_name: Moon-Userbot
    restart: unless-stopped
    volumes:
      - <yourPath>/data:/app/data
      - /dev/null:/app/modules/example.py # easy way to disable modules, throws errors but who cares
    environment:
      - API_ID=
      - API_HASH=
      - DATABASE_TYPE=sqlite3
      - DATABASE_NAME=data/db.sqlite3
      - STRINGSESSION=
      - PM_LIMIT=999
      - APIFLASH_KEY=
      - RMBG_KEY=
      - VT_KEY=
      - GEMINI_KEY=
      - COHERE_KEY=
```

## Getting your Telegram credentials

### API_ID and API_HASH

Get your API_ID and API_HASH from [my.telegram.org](https://my.telegram.org).
Feel free to follow [this](https://core.telegram.org/api/obtaining_api_id) official guide.

### STRINGSESSION

You can use this Docker Image to generate your string session.

```bash
docker run -it --rm watn3y/moonuserbot:latest string_gen.py
```
