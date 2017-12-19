# Code pulled from https://github.com/GoogleChrome/puppeteer/blob/master/docs/troubleshooting.md

FROM node:8

LABEL maintainer="derek@provance.me"

# Install latest chrome package.
# Note: this installs the necessary libs to make the bundled version of Chrome
# that Puppeteer installs, work.
RUN apt-get update && apt-get install -y wget --no-install-recommends \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    && apt-get update \
    && apt-get install -y google-chrome-unstable \
      --no-install-recommends \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get purge --auto-remove -y curl \
    && rm -rf /src/*.deb

# We do not want to use the bundled puppeteer chromium download
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD true

# Install puppeteer so it's available in the container.
RUN yarn add puppeteer

# Add puppeteer user (pptruser).
RUN groupadd -r pptruser && useradd -r -g pptruser -G audio,video pptruser \
    && mkdir -p /home/pptruser/Downloads \
    && chown -R pptruser:pptruser /home/pptruser \
    && chown -R pptruser:pptruser /node_modules

# Run user as non privileged.
USER pptruser

CMD ["google-chrome-unstable"]
