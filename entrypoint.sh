#!/bin/bash

rm -rf tmp/pids/server.pid

service mariadb start
mysql_secure_installation <<EOF

y
SOL@DEFAULT22243Pssd!
SOL@DEFAULT22243Pssd!
y
y
y
y
EOF
export RUBYOPT='-W:no-deprecated -W:no-experimental'

(mysql -e "select name from sdc_api_development.admins limit 1" || (rails db:create && mysql sdc_api_development < dev.sql && echo "ok")) && bundle exec foreman start

RUBYOPT='-W:no-deprecated -W:no-experimental' rails db:create 
RUBYOPT='-W:no-deprecated -W:no-experimental' rails db:migrate

RUBYOPT='-W:no-deprecated -W:no-experimental' rails sol_credentials:setup

RUBYOPT='-W:no-deprecated -W:no-experimental' bundle exec foreman start