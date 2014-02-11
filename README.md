capistrano-deploy_vagrant-wordpress
===================================

Example of deployed to Vagrant Vm using capistrano3

Add your ```/etc/hotsts``` file

```
192.168.33.10 wordpress.dev
192.168.33.10 staging-wordpress.dev
```

setup

```
bundle install
vagrant up
```

depoloy

```
# deploy staging
bundle exec cap deploy staging # see your browser http://staging-wordpress.dev/
bundle exec cap deploy production # see your browser http://wordpress.dev/
```
