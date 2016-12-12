role :app, %w{participa@participa.unpaisencomu.cat}
role :web, %w{participa@participa.unpaisencomu.cat}
role :db,  %w{participa@participa.unpaisencomu.cat}

set :branch, ENV['BRANCH'] || :master
set :deploy_to, '/home/participa/betaparticipa.unpaisencomu.cat'

after 'deploy:publishing', 'deploy:restart'
