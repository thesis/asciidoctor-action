FROM ruby:alpine

RUN gem install asciidoctor asciidoctor-diagram

RUN apk add bash nodejs npm

RUN mkdir /mermaid

WORKDIR /mermaid

COPY mermaid-package.json package.json
COPY mermaid-package-lock.json package-lock.json

# --silent because otherwise we get warnings about the tiny package.json we're
# using. We don't really have a named package here, we just want to specify
# some dependencies.
RUN npm install --silent @mermaid-js/mermaid-cli

RUN chmod -R o+rwx /mermaid/node_modules

RUN /bin/bash -c 'echo "export PATH=/mermaid/node_modules/.bin:\$PATH" > /etc/profile.d/mermaid.sh'

USER nobody

ENTRYPOINT ["/bin/bash", "--login"]
