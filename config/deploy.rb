set :deploy_to, "/home/rails-praxis/rails"
set :application, "rails-praxis.de"

set :user, "rails-praxis"

role :web, "rails-praxis@moria.invisible.ch"
role :app, "rails-praxis@moria.invisible.ch"
role :db,  "rails-praxis@moria.invisible.ch", :primary => true



set :use_sudo, false
set :keep_releases, 4

set :scm, :git
set :branch, "master"
set :repository, "git@github.com:jcfischer/referenz2.git"
set :deploy_via, :remote_cache


namespace :deploy do
  desc "Restart Application"
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end
end



after :'deploy:update_code', :link_assets
before :'deploy:restart', :'ultrasphinx:daemon_stop', :'ultrasphinx:config', :'ultrasphinx:daemon_start'

task :link_assets, :roles => [:app] do
  run <<-CMD
  cp #{shared_path}/database.production.yml #{release_path}/config/database.yml &&
  ln -nfs #{shared_path}/files #{release_path}/files &&
  chmod 777 #{release_path}/public/images

  CMD
end

# ==========================
# Sphinx Server Tasks
# ==========================
namespace :ultrasphinx do
  
  desc "Create Config File"
  task :config, :roles => :app do
    invoke_command "cd #{current_path} && rake ultrasphinx:configure RAILS_ENV=production"
  end
  desc "Update Index"
  task :index, :roles => :app do
    invoke_command "cd #{current_path} && rake ultrasphinx:index RAILS_ENV=production"
  end

  desc "Stop Sphinx"
  task :daemon_stop, :roles => :app do
    invoke_command "cd #{current_path} && rake ultrasphinx:daemon:stop RAILS_ENV=production"
  end

  desc "Start Sphinx"
  task :daemon_start, :roles => :app do
    invoke_command "cd #{current_path} && rake ultrasphinx:daemon:start RAILS_ENV=production"
  end

  desc "Restart Sphinx"
  task :daemon_restart, :roles => :app do
    invoke_command "cd #{current_path} && rake ultrasphinx:daemon:restart RAILS_ENV=production"
  end
end