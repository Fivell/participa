# Load DSL and Setup Up Stages
require 'capistrano/setup'

# Includes default deployment tasks
require 'capistrano/deploy'

# Git SCM by default
require 'capistrano/scm/git'
install_plugin Capistrano::SCM::Git

#   https://github.com/capistrano/bundler
#   https://github.com/capistrano/rails
#
require 'capistrano/bundler'
require 'capistrano/rails/assets'
require 'capistrano/rails/migrations'
require 'capistrano/passenger/no_hook'


# Loads custom tasks from `lib/capistrano/tasks' if you have any defined.
Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }
