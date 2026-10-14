FROM alpine:latest AS builder

RUN apk add git
WORKDIR /app
RUN TAG=$(git ls-remote --tags --refs --sort=-v:refname https://github.com/The-MoonTg-project/Moon-Userbot.git | head -n1 | sed 's|.*refs/tags/||') \
    && git clone --depth 1 --branch "$TAG" https://github.com/The-MoonTg-project/Moon-Userbot.git .

FROM python:3.11-slim

# Make a failure anywhere in a pipe fail the RUN step
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
RUN pip install -U yt-dlp-ejs curl_cffi yt-dlp

# Directory for the sqlite DB (DATABASE_NAME=data/db.sqlite3); mount a volume here to persist it
RUN mkdir -p /app/data

ENTRYPOINT [ "python" ]
CMD ["main.py"]
