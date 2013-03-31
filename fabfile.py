
from fabric.api import *

env.hosts = ['norton.pudo.org']
deploy_dir = '/var/www/spon-api.pudo.org/'

remote_user = 'fl'

def deploy():
    with cd(deploy_dir + 'app'):
        run('git pull')
        run('git reset --hard HEAD')
        run('npm install .')
    sudo('supervisorctl reread')
    sudo('supervisorctl restart spon-api.pudo.org')
    run('curl -X PURGEDOMAIN http://spon-api.pudo.org')

def install():
    sudo('rm -rf ' + deploy_dir)
    sudo('mkdir -p ' + deploy_dir)
    sudo('chown -R ' + remote_user + ' ' + deploy_dir)
    put('deploy/*', deploy_dir)

    sudo('mv ' + deploy_dir + 'nginx.conf /etc/nginx/sites-available/spon-api.pudo.org')
    sudo('service nginx restart')

    sudo('ln -sf /etc/nginx/sites-available/spon-api.pudo.org /etc/nginx/sites-enabled/spon-api.pudo.org')
    sudo('ln -sf ' + deploy_dir + 'supervisor.conf /etc/supervisor/conf.d/spon-api.pudo.org.conf')
    run('mkdir ' + deploy_dir + 'logs')
    sudo('chown -R www-data.www-data ' + deploy_dir + 'logs')
    sudo('supervisorctl reread')
    sudo('supervisorctl reload')

    with cd(deploy_dir):
        run('git clone git@github.com:pudo/spon-api.git app')

    deploy()
