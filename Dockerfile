FROM qbtaumai/moonuserbot:latest

RUN curl -fsSL https://deno.land/install.sh | bash -s -- -y > /dev/null 2>&1
RUN pip install -q -U yt-dlp-ejs curl_cffi yt-dlp
