FROM ruby:2.7.7
WORKDIR /app
COPY Gemfile /app/Gemfile
RUN bundle install
COPY bin/setup /app/bin/setup
COPY entrypoint.sh /app/entrypoint.sh
COPY . /app/
RUN curl -fsSL https://packages.redis.io/gpg | gpg --dearmor -o /usr/share/keyrings/redis-archive-keyring.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/redis-archive-keyring.gpg] https://packages.redis.io/deb bullseye main" | tee /etc/apt/sources.list.d/redis.list
RUN apt-get update -y
RUN apt-get install redis -y
ENTRYPOINT '/app/entrypoint.sh'
# RUN bin/setup
# COPY Gemfile.lock /app/Gemfile.lock
# RUN rails setup:load
# RUN rake oauth:applications:load
# RUN bundle exec foreman start
# RUN bash