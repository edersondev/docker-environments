FROM nginx:1.21.6

COPY default.conf /etc/nginx/conf.d/default.conf

COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["nginx", "-g", "daemon off;"]
