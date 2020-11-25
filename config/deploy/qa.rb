server "api.solsenar.senar.org.br", user: "sdc", roles: %w{app db web sidekiq}
set :sidekiq_service, 'qa.sdc-api.sidekiq.service'
set :cron_user, 'sdc'

set :repo_url, "https://github.com/caiena/sol-api.git"
