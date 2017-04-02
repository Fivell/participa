# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'
require 'resque/tasks'
task 'resque:setup' => :environment

Rails.application.load_tasks

if %(test development).include?(Rails.env)
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new

  require 'rake/testtask'
  Rake::TestTask.new(:test) do |t|
    t.libs << 'lib' << 'test'
    t.pattern = 'test/**/*_test.rb'
    t.warning = false
  end

  task default: [:test, :rubocop]
end
