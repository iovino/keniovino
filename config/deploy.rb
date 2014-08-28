set :application,   "keniovino"
set :repository,    "git@github.com:EscalateMedia/em-newsletter.git"
set :deploy_to,     "/var/www/keniovino"
set :user,          "pi"
set :scm,           "git"
set :keep_releases, "10"
set :deploy_via,    :remote_cache
set :ssh_options,   {:forward_agent => true}
set :branch, current_branch

role :web, 50.88.247.176
role :app, 50.88.247.176
role :db,  50.88.247.176, :primary => true

default_run_options[:pty] = true

#
# Function to fetch branch name
#

def current_branch
  branch = `git symbolic-ref HEAD 2> /dev/null`.strip.gsub(/^refs\/heads\//, '')
  puts "Deploying branch #{branch}"
  branch
end

#
# Deploy Tasks
#

namespace :deploy do

  # Create the app file using the sample file provided
  task :create_app_file, :roles => :app do
    sudo "cp #{release_path}/app.sample.php #{release_path}/app.php"
    puts "App file created"
  end

end

after "deploy",                 "deploy:create_app_file"
after "deploy:create_app_file", "deploy:cleanup"