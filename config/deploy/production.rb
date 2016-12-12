server 'participa.unpaisencomu.cat', roles: %w(db web app)

set :branch, ENV['BRANCH'] || :master
set :deploy_to, '/home/participa/participa.unpaisencomu.cat'

after 'deploy:publishing', 'deploy:restart'
