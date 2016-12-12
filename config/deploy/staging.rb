role :app, %w{participa@betaparticipa.unpaisencomu.cat}
role :web, %w{participa@betaparticipa.unpaisencomu.cat}
role :db,  %w{participa@betaparticipa.unpaisencomu.cat}

set :branch, ENV['BRANCH'] || :master
set :deploy_to, '/home/participa/betaparticipa.unpaisencomu.cat'

after 'deploy:publishing', 'deploy:restart'
