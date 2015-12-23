
mkdir /etc/puppet/manifests
mkdir /etc/puppet/modules
cd /etc/puppet/modules

file=`ls -t /var/www/html/puppet-modules/LunetIX-git* |head -1`
tar xvfz $file
mv LunetIX-git* git

file=`ls -t /var/www/html/puppet-modules/LunetIX-buildhost* |head -1`
tar xvfz $file
mv LunetIX-buildhost* buildhost

cp buildhost/examples/site.pp /etc/puppet/manifests

wget https://forgeapi.puppetlabs.com/v3/files/rtyler-jenkins-1.6.1.tar.gz
tar xvfz rtyler-jenkins-1.6.1.tar.gz
rm rtyler-jenkins-1.6.1.tar.gz
mv rtyler-jenkins* jenkins

wget https://forgeapi.puppetlabs.com/v3/files/puppetlabs-postgresql-4.6.1.tar.gz
tar xvfz puppetlabs-postgresql-4.6.1.tar.gz
rm puppetlabs-postgresql-4.6.1.tar.gz
mv puppetlabs-postgresql* postgresql

wget https://forgeapi.puppetlabs.com/v3/files/camptocamp-archive-0.8.1.tar.gz
tar xvfz camptocamp-archive-0.8.1.tar.gz
rm camptocamp-archive-0.8.1.tar.gz
mv camptocamp-archive* archive

wget https://forgeapi.puppetlabs.com/v3/files/puppetlabs-concat-1.2.5.tar.gz
tar xvfz puppetlabs-concat-1.2.5.tar.gz
rm puppetlabs-concat-1.2.5.tar.gz
mv puppetlabs-concat* concat

wget https://forgeapi.puppetlabs.com/v3/files/puppetlabs-java-1.4.3.tar.gz
tar xvfz puppetlabs-java-1.4.3.tar.gz
rm puppetlabs-java-1.4.3.tar.gz
mv puppetlabs-java* java

wget https://forgeapi.puppetlabs.com/v3/files/puppetlabs-stdlib-4.10.0.tar.gz
tar xvfz puppetlabs-stdlib-4.10.0.tar.gz
rm puppetlabs-stdlib-4.10.0.tar.gz
mv puppetlabs-stdlib* stdlib


puppet apply /etc/puppet/manifests/site.pp
