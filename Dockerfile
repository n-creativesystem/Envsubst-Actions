FROM alpine:3

RUN apk --no-cache add libintl && \
      apk --no-cache add --virtual .gettext gettext && \
      cp /usr/bin/envsubst /usr/local/bin/envsubst && \
      apk del .gettext

COPY ./entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]