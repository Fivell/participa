server 'betaparticipa.unpaisencomu.cat', port: 22014, roles: %w(db web app)

set :branch, ENV['BRANCH'] || :master
set :deploy_to, '/home/participa/betaparticipa.unpaisencomu.cat'
