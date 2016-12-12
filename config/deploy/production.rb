server 'participa.unpaisencomu.cat', port: 22015, roles: %w(db web app)

set :branch, ENV['BRANCH'] || :master
set :deploy_to, '/home/participa/participa.unpaisencomu.cat'

after 'deploy:publishing', 'deploy:restart'
