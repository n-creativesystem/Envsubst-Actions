FROM scratch as client

ENV DOCKER_CLIENT_VERSION=19.03.8
ENV DOCKER_API_VERSION=1.40
ADD https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_CLIENT_VERSION}.tgz .

FROM debian
ARG ARG_DOCKER_CLIENT_VERSION=19.03.8
ENV TZ=Asia/Tokyo
ENV DOCKER_CLIENT_VERSION=${ARG_DOCKER_CLIENT_VERSION}
ENV DOCKER_API_VERSION=1.40
COPY --from=client docker-${DOCKER_CLIENT_VERSION}.tgz .

RUN apt-get update \
    && apt-get install -y git openssh-client curl \
    && tar xzvf docker-${DOCKER_CLIENT_VERSION}.tgz \
    && mv docker/* /usr/bin/ \
    && rm -rf docker-${DOCKER_CLIENT_VERSION}.tgz

ADD https://raw.githubusercontent.com/nektos/act/master/install.sh /tmp/act/
RUN bash /tmp/act/install.sh

WORKDIR /src

CMD [ "bash" ]
