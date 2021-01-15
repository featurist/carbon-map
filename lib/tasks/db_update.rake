# frozen_string_literal: true
namespace :db_update do
  task :production do
    app_name = ENV['CARBON_MAP_APP_NAME']
    unless app_name
      $stdout.puts 'Heroku app name?'
      app_name = $stdin.gets.strip.downcase
    end

    sh "heroku pg:backups:download -a #{app_name}"

    sh 'dropdb carbon_map_development --if-exists'
    sh 'createdb carbon_map_development'

    begin
      sh 'PGGSSENCMODE=disable pg_restore --verbose --clean --no-acl --no-owner' \
        ' -d carbon_map_development latest.dump'
    rescue RuntimeError => e
      puts '----------------------------------------------------'
      puts 'IGNORING ERRORS! by pg_restore (Double check the above errors are OK!)'
      puts e.message
      puts '----------------------------------------------------'
    end

    sh 'rails db:migrate'
  end
end
