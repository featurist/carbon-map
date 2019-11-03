# frozen_string_literal: true

def cors(host)
  [
    {
      "origin": [host],
      "responseHeader": ["Content-Type", "Content-Md5"],
      "method": ["PUT", "GET", "HEAD", "DELETE"],
      "maxAgeSeconds": 3600
    }
  ]
end

def update_cors(host, bucket)
  File.write 'tmp/cors.json', cors(host).to_json
  `gsutil cors set tmp/cors.json gs://#{bucket}`
end

require 'csv'

namespace :gcs do
  desc 'Import taxonomy from csv'
  task :dev do
    update_cors('*', 'carbon-map-dev')
  end

  task :staging do
    `heroku config:set GOOGLE_APPLICATION_CREDENTIALS="$(< config/secrets/google-carbon-map-staging.json)" -a carbon-map`
    update_cors('https://carbon-map.herokuapp.com', 'carbon-map-staging')
  end

  task :production do
    update_cors('https://<inert-url', 'carbon-map')
  end
end
