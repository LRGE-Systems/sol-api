FROM ubuntu:18.04
RUN apt update
RUN apt install ruby-full wget -y
RUN apt install build-essential -y
ENV BUNDLER_VERSION=2.1.4
RUN gem install bundler -v '2.1.4'
WORKDIR /opt

RUN wget http://download.redis.io/releases/redis-6.0.8.tar.gz && tar xzf redis-6.0.8.tar.gz && cd redis-6.0.8 && make
RUN ln -sf /opt/redis-6.0.8/src/redis-server /usr/bin/

WORKDIR /app

RUN apt install git -y

RUN apt install  zlib1g-dev libxml2-dev libcurl4-openssl-dev libpq-dev -y

COPY Gemfile /app/Gemfile
# COPY Gemfile.lock /app/Gemfile.lock
RUN bundle install

COPY . /app

ENTRYPOINT '/app/entrypoint.sh'

