role :app, %w{participa@participa.barcelonaencomu.cat}
role :web, %w{participa@participa.barcelonaencomu.cat}
role :db,  %w{participa@participa.barcelonaencomu.cat}

set :branch, ENV['BRANCH'] || :master
set :deploy_to, '/srv/rails/participa.barcelonaencomu.cat'

after 'deploy:publishing', 'deploy:restart'
