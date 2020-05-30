FROM ruby:alpine

RUN gem install asciidoctor asciidoctor-pdf asciidoctor-diagram

RUN apk add nodejs npm bash

RUN mkdir /mermaid

WORKDIR /mermaid

COPY mermaid-package.json package.json
COPY mermaid-package-lock.json package-lock.json

# --silent because otherwise we get warnings about the tiny package.json we're
# using. We don't really have a named package here, we just want to specify
# some dependencies.
RUN npm install --silent @mermaid-js/mermaid-cli

ENV PATH /mermaid/node_modules/.bin:/usr/local/bundle/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
