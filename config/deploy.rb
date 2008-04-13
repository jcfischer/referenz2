set :application, "rails-praxis"

role :app, "praxis@8.7.217.152"
role :web, "praxis@8.7.217.152"
role :db,  "praxis@8.7.217.152", :primary => true

set :user, "praxis"
set :repository,  "git@github.com:jcfischer/referenz2.git"

set :scm, :git
set :git_enable_submodules, 1
# set :deploy_via, :remote_cache
set :branch, 'origin/master'
# set :deploy_via, :copy


set :deploy_to, "/opt/rails/#{application}"

set :smf, "mongrel/cluster:rails-praxis"


set :group_writable, false


set :sudo, "/opt/csw/bin/sudo"
set :rake, "/opt/csw/bin/rake"
set :git, "/opt/csw/bin/git"

set :service_list, "`svcs -H -o FMRI svc:application/mongrel/#{application}-production`"

after :'deploy:update_code', :link_assets
before :'deploy:restart', :'ultrasphinx:daemon_stop', :'ultrasphinx:config', :'ultrasphinx:daemon_start'

task :link_assets, :roles => [:app] do
  run <<-CMD
  cp #{shared_path}/database.production.yml #{release_path}/config/database.yml
  CMD
end

namespace :mongrel do

  namespace :cluster do
    task :start, :roles => :app do
      sudo "svcadm enable #{service_list}"
    end

    task :stop, :roles => :app do
      sudo "svcadm disable #{service_list}"
    end

    task :restart, :roles => :app do
      sudo "svcadm restart #{service_list}"
    end
  end

end

namespace :deploy do
  task :start do
    via = fetch(:run_method, :sudo)
    invoke_command "/usr/sbin/svcadm enable #{service_list}", :via => via
  end

  task :stop, :roles => :app do
    via = fetch(:run_method, :sudo)
    invoke_command "svcadm disable #{service_list}"
  end

  task :restart do
    via = fetch(:run_method, :sudo)
    invoke_command "/usr/sbin/svcadm disable #{service_list}", :via => via
    invoke_command "/usr/sbin/svcadm enable #{service_list}", :via => via

  end
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
