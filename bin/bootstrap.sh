#!/usr/bin/env bash
# http://docs.vagrantup.com/v2/getting-started/provisioning.html

USER=vagrant

sudo apt-get update
sudo apt-get install -y postgresql \
                        imagemagick \
                        redis-server \
                        curl \
                        git \
                        libpq-dev \
                        build-essential \
                        qt5-default \
                        libqt5webkit5-dev \
                        wkhtmltopdf \
                        nodejs

rm -rf /usr/local/rvm

cat > /home/vagrant/.gemrc <<EOF
gem: --no-ri --no-rdoc
EOF

sudo -u postgres psql -c "CREATE USER participa WITH NOSUPERUSER \
                                                     CREATEDB \
                                                    NOCREATEROLE \
                                                    PASSWORD 'participa'"

cat > /home/vagrant/deploy.sh <<EOF
#!/usr/bin/env bash

set -x

if [ ! -d ~/.rvm ] ; then
  gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
  curl -sSL https://get.rvm.io | bash -s stable 
fi

source ~/.rvm/scripts/rvm
rvm use --install 2.2.2 
ruby --version
gem install bundler

cd /vagrant
bundle install

cp config/database.yml.example config/database.yml
cp config/secrets.yml.example config/secrets.yml

bundle exec rake db:create
bin/rake db:migrate
bin/mailcatcher
bin/rails server -b 0.0.0.0 
EOF

# TODO: start resque

chmod +x /home/vagrant/deploy.sh 

su - vagrant -c "/home/vagrant/deploy.sh" 
