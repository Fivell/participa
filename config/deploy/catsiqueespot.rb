role :app, %w{capistrano@catsiqueespot.podemos.info}
role :web, %w{capistrano@catsiqueespot.podemos.info}
role :db,  %w{capistrano@catsiqueespot.podemos.info}

set :repo_url, 'git@github.com:podemos-info/participa.git'
set :branch, :catsiqueespot
set :rails_env, :production
set :deploy_to, '/var/www/participa.podemos.info'

after 'deploy:publishing', 'deploy:restart'
