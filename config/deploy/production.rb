server 'participa.unpaisencomu.cat', port: 22015, roles: %w(db web app)

set :branch, :master
set :deploy_to, '/home/participa/participa.unpaisencomu.cat'
