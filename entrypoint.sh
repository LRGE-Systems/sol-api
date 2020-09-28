#!/bin/bash
/usr/bin/env ruby /app/bin/setup
rm /app/tmp/pids/server.pid
bundle exec foreman start