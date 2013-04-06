#!/bin/bash

##
## install puppet 3.0 on centos 6.3
##
##

yum -y install nano screen telnet

#stop iptables and firewall
chkconfig iptables off
chkconfig ip6tables off
service iptables stop
service ip6tables stop
setenforce 0


touch /etc/yum.repos.d/puppet.repo
cat > /tmp/mysql_sec_script<<EOF
[puppetlabs]
name=Puppet Labs Packages
baseurl=http://yum.puppetlabs.com/el/$releasever/products/$basearch/
enabled=1
gpgcheck=1
gpgkey=http://yum.puppetlabs.com/RPM-GPG-KEY-puppetlabs
EOF

#install packages
rpm -ivh http://mirror.bytemark.co.uk/fedora/epel/6/i386/epel-release-6-7.noarch.rpm

#install ruby new version
wget http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.3-p327.tar.gz
tar –zxvf ruby-1.9.3-p327.tar.gz
cd ruby-1.9.3-p327
./configure
make && make install

#install server and client
yum -y install puppet-server puppet

#set config
cat > /etc/puppet/puppet.conf<<EOF
[master]
certname = hostname.domainname.com
autosign = true
EOF

#start
/etc/init.d/puppetmaster start
chkconfig puppetmaster on

#stop
#/etc/init.d/puppetmaster stop
#chkconfig puppetmaster off


#install apache passenger
yum -y install httpd httpd-devel ruby-devel rubygems mod_ssl make gcc gcc-c++ curl-devel openssl-devel zlib-devel
gem install rack
gem install passenger


passenger-install-apache2-module


cat > /etc/httpd/conf.d/puppetmaster.conf<<EOF
Listen 8140
LoadModule passenger_module /usr/lib/ruby/gems/1.8/gems/passenger-3.0.17/ext/apache2/mod_passenger.so
PassengerRoot /usr/lib/ruby/gems/1.8/gems/passenger-3.0.17
PassengerRuby /usr/bin/ruby
    
<VirtualHost *:8140>
    SSLEngine on
    SSLCipherSuite SSLv2:-LOW:-EXPORT:RC4+RSA
    #ensure the certfiles are correct for puppet master
    SSLCertificateFile      /var/lib/puppet/ssl/certs/hostname.domainname.com.pem
    SSLCertificateKeyFile   /var/lib/puppet/ssl/private_keys/hostname.domainname.com.pem
    SSLCertificateChainFile /var/lib/puppet/ssl/ca/ca_crt.pem
    SSLCACertificateFile    /var/lib/puppet/ssl/ca/ca_crt.pem
    # CRL checking should be enabled; if you have problems with Apache complaining about the CRL, disable the next line
    SSLCARevocationFile     /var/lib/puppet/ssl/ca/ca_crl.pem
    SSLVerifyClient optional
    SSLVerifyDepth  1
    SSLOptions +StdEnvVars
    # The following client headers allow the same configuration to work with Pound.
    RequestHeader set X-SSL-Subject %{SSL_CLIENT_S_DN}e
    RequestHeader set X-Client-DN %{SSL_CLIENT_S_DN}e
    RequestHeader set X-Client-Verify %{SSL_CLIENT_VERIFY}e
    RackAutoDetect On
    DocumentRoot /usr/share/puppet/rack/puppetmasterd/public/
    <Directory /usr/share/puppet/rack/puppetmasterd/>
        Options None
        AllowOverride None
        Order allow,deny
        allow from all
    </Directory>
</VirtualHost>
EOF

#copy configuration
cp /usr/share/puppet/ext/rack/files/config.ru /usr/share/puppet/rack/puppetmasterd

mkdir /var/lib/puppet/.puppet
chown puppet.puppet /var/lib/puppet/.puppet


#set auto start http
chkconfig httpd on
service httpd start


#show http run log
tail -f /var/log/httpd










