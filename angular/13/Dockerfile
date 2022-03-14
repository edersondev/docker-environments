FROM node:16-bullseye-slim
LABEL maintainer="Ederson Ferreira <ederson.dev@gmail.com>"

RUN npm i -g @angular/cli@13.1.2
RUN npm i -g npm-check-updates@latest

COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

WORKDIR /var/angular

EXPOSE 4200

