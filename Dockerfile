FROM alpine:latest AS builder

RUN apk add git
WORKDIR /app
RUN TAG=$(git ls-remote --tags --refs --sort=-v:refname https://github.com/The-MoonTg-project/Moon-Userbot.git | head -n1 | sed 's|.*refs/tags/||') \
    && git clone --depth 1 --branch "$TAG" https://github.com/The-MoonTg-project/Moon-Userbot.git .

FROM python:3.11-slim


LABEL org.opencontainers.image.title="Moon-Userbot" \
    org.opencontainers.image.description="Automated Docker builds of Moon-Userbot with support for arm64 and including more dependencies." \
    org.opencontainers.image.authors="watn3y <me@watn3y.de>" \
    org.opencontainers.image.vendor="watn3y.de" \
    org.opencontainers.image.documentation="https://git.watn3y.de/watn3y/Moon-Userbot-Docker/src/branch/master/README.md" \
    org.opencontainers.image.url="https://git.watn3y.de/watn3y/Moon-Userbot-Docker" \
    org.opencontainers.image.source="https://git.watn3y.de/watn3y/Moon-Userbot-Docker" \
    org.opencontainers.image.licenses="GPL-3.0-or-later" \
    org.opencontainers.image.base.name="docker.io/library/python:3.11-slim" 

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

WORKDIR /app
COPY --from=builder /app /app
RUN apt-get -q update \
    && DEBIAN_FRONTEND=noninteractive apt-get -q install -y git wget curl unzip ffmpeg mediainfo build-essential \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
RUN python -m venv --copies /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
RUN pip install --no-cache-dir -r requirements.txt

RUN curl -fsSL https://deno.land/install.sh | bash -s -- -y
ENV PATH="/root/.deno/bin:$PATH"
RUN pip install -U --no-cache-dir yt-dlp-ejs curl_cffi yt-dlp


RUN mkdir -p /app/data

ENTRYPOINT [ "python" ]
CMD ["main.py"]
