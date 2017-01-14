server 'betaparticipa.unpaisencomu.cat', port: 22014, roles: %w(db web app)

set :branch, -> { `git rev-parse --abbrev-ref HEAD`.chomp }
set :deploy_to, '/home/participa/betaparticipa.unpaisencomu.cat'
