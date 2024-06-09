namespace :sol_credentials do
    desc 'make credentials keys for frontend and show them all'
    task setup: :environment do |task|
        creds = Doorkeeper::Application.all
        if creds.blank?
            system("bundle exec rake oauth:applications:load")
            show
        else 
            show
        end
    end

    def show
        creds = Doorkeeper::Application.all
        creds.each do |a|
            puts "CREDENTIALS"
            puts "NAME: #{a.name}"
            puts "UID: #{a.uid}"
            puts "SECRET: #{a.secret}"
        end
    end
end
