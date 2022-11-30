#!/bin/bash

rm -rf tmp/pids/server.pid
bin/setup
# rails setup:load
# rake oauth:applications:load
bundle exec foreman start