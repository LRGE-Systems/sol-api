namespace :setup do
  desc 'initial setup rake'
  task load: :environment do |task|

    tasks = [
      'sol_sample_users:setup',
      'setup:cities:load',
      'setup:classifications:load',
      'setup:integrations:load',
      'oauth:applications:load'
    ]

    tasks.each { |task| with_feedback(task) { Rake::Task[task].invoke } }
  end

  def with_feedback(task)
    spinner = TTY::Spinner.new("[:spinner] #{task}")
    spinner.auto_spin
    begin
      yield
    rescue => e
      spinner.error("- Erro: #{e.message}")
    end

    spinner.success
  end
end
