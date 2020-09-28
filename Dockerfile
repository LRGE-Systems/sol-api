FROM ruby:2.5.1
ENV BUNDLER_VERSION=2.1.4

WORKDIR /opt

RUN wget http://download.redis.io/releases/redis-6.0.8.tar.gz && tar xzf redis-6.0.8.tar.gz && cd redis-6.0.8 && make
RUN ln -sf /opt/redis-6.0.8/src/redis-server /usr/bin/

WORKDIR /app
COPY . /app

ENTRYPOINT '/app/entrypoint.sh'
