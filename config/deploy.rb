load 'deploy/assets'
require "bundler/capistrano"
require "rvm/capistrano"

set :rvm_type, :user  # Don't use system-wide RVM
set :rvm_ruby_string, "ruby-1.9.3-p392"

set :application, "rmsonrails"
set :repository,  "git@github.com:barnaba/rmsonrails.git"
set :branch, "master"
ssh_options[:forward_agent] = true
set :rails_env, "production"
set :keep_releases, 4
set :deploy_to, "/home/turekb/rmsonrails/"
set :use_sudo, false
set :user, "turekb"


# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "rms2013.pl"                          # Your HTTP server, Apache/etc
role :app, "rms2013.pl"                          # This may be the same as your `Web` server
role :db,  "rms2013.pl", :primary => true # This is where Rails migrations will run

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

namespace(:customs) do
  task :config, :roles => :app do
    run <<-CMD
      ln -nfs #{shared_path}/config/database.yml #{release_path}/config/
      ln -nfs #{shared_path}/config/application.yml #{release_path}/config/
      ln -nfs #{shared_path}/config/newrelic.yml #{release_path}/config/
    CMD
  end
end

after "deploy:finalize_update", "customs:config"
after "deploy", "deploy:cleanup"
