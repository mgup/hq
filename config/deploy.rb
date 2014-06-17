set :rvm_type, :user
require 'rvm/capistrano'
require 'bundler/capistrano'
require 'dotenv/capistrano'
require 'airbrake/capistrano'
require 'capistrano/sidekiq'

set :application, 'matrix'
set :repository,  'git@github.com:mgup/hq.git'
set :user,        'matrix'
set :use_sudo,    false
set :deploy_to,   "/home/#{user}/webapps/#{application}"
set :scm,         :git

set :deploy_via,       :remote_cache
set :ssh_options,      { forward_agent: true }
set :repository_cache, 'git_cache'

role :web, 'matrix2.mgup.ru'
role :app, 'matrix2.mgup.ru'
role :db,  'matrix2.mgup.ru', primary: true

# set :normalize_asset_timestamps, false
#set :asset_env, "#{asset_env} RAILS_RELATIVE_URL_ROOT=/"

before 'deploy:restart', 'deploy:migrate'
after  'deploy:restart', 'deploy:cleanup'

namespace :deploy do
  task :start do
    run "touch #{current_release}/tmp/restart.txt"
  end

  task :stop do ; end

  task :restart, roles: :app do
    run "touch #{current_release}/tmp/restart.txt"
  end
end

# require './config/boot'
