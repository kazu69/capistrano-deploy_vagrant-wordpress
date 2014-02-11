set :application, 'wordpress'
set :repo_url, 'git@github.com:WordPress/WordPress.git'
# set :deploy_to, '/var/www/wordpress'
# set :document_root, '/var/www/html'
set :scm, :git
set :pty, true
set :stages, %w(staging production)
set :default_stage, 'staging'
set :use_sudo, false
set :keep_releases, 5
set :deploy_via, :remote_cache
set :user, 'vagrant'
set :copy_exclude, ['license.txt', 'readme.html', '.git', '.DS_Store', '.gitignore']

I18n.enforce_available_locales = true

def file_dir_or_symlink_exists?(path_to_file)
  File.exist?(path_to_file) || File.symlink?(path_to_file)
end

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  task :symlink do
    on roles(:app) do
      execute "rm -rf /var/www/#{fetch(:stage)}/public/current" unless file_dir_or_symlink_exists?("/var/www/#{fetch(:stage)}/public/current")
      execute "ln -nfs /var/www/#{fetch(:stage)}/current /var/www/#{fetch(:stage)}/public"
      execute "ln -nfs #{shared_path}/uploads #{release_path}/uploads"
      execute "ln -nfs #{shared_path}/wp-config.php #{release_path}/wp-config.php"
      execute "ln -nfs #{shared_path}/.htaccess #{release_path}/.htaccess"
    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  after :finishing, 'deploy:cleanup'
  after 'symlink:release', 'deploy:symlink'

end
