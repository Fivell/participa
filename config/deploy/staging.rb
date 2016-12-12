server 'betaparticipa.unpaisencomu.cat', roles: %w(db web app)

set :branch, ENV['BRANCH'] || :master
set :deploy_to, '/home/participa/betaparticipa.unpaisencomu.cat'

after 'deploy:publishing', 'deploy:restart'
