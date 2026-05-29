FROM alpine:latest AS builder

RUN apk add git
WORKDIR /app
RUN TAG=$(git ls-remote --tags --refs --sort=-v:refname https://github.com/The-MoonTg-project/Moon-Userbot.git | head -n1 | sed 's|.*refs/tags/||') \
    && git clone --depth 1 --branch "$TAG" https://github.com/The-MoonTg-project/Moon-Userbot.git .

FROM python:3.11-slim

WORKDIR /app
COPY --from=builder /app /app
RUN apt-get -qq update && apt-get -qq install -y git wget ffmpeg mediainfo build-essential \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
RUN python -m venv --copies /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
RUN pip install --no-cache-dir -r requirements.txt

RUN curl -fsSL https://deno.land/install.sh | bash -s -- -y > /dev/null 2>&1
RUN pip install -q -U yt-dlp-ejs curl_cffi yt-dlp

CMD ["python", "main.py"]
