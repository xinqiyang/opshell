#/bash
# author:xinqiyang
# version 0.0.1 build 20130222
# need todo ...... 
#
#
# Install:
# chmod u+x buildEnv.sh;
#./buildEnv.sh ins_full;
#./buildEnv.sh upsys;
#./buildEnv.sh init; 
#./buildEnv.sh ins_mysql-server; 
#./buildEnv.sh ins_mysql-client; 
#./buildEnv.sh ins_php; 
#./buildEnv.sh ins_phpext; 
#./buildEnv.sh ins_mysql
#./buildEnv.sh ins_redis


nginx_dir="/usr/local/nginx"
php_dir="/usr/local/php"
mysql_dir="/usr/local/mysql"


function upsys()
{
LANG=C
yum -y install wget gcc gcc-c++ autoconf libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel libxml2 libxml2-devel zlib zlib-devel glibc glibc-devel glib2 glib2-devel bzip2 bzip2-devel ncurses ncurses-devel curl curl-devel e2fsprogs e2fsprogs-devel krb5 krb5-devel libidn libidn-devel openssl openssl-devel openldap openldap-devel nss_ldap openldap-clients openldap-servers
}


#init  downloa packages 
function init()
{
read -p "Now,starting download softwares...Y|y:" buildEnv.sh

case "$nginxphp" in

Y|y)

echo -n "starting download components ..."
cat > list << "EOF" &&
nginx-1.0.8.tar.gz
php-5.2.17.tar.gz
php-5.2.17-fpm-0.5.14.diff.gz
libiconv-1.13.1.tar.gz
libmcrypt-2.5.8.tar.gz
mcrypt-2.6.8.tar.gz
memcache-2.2.5.tgz
mhash-0.9.9.9.tar.gz
mysql-5.1.52.tar.gz
pcre-8.10.tar.gz
eaccelerator-0.9.6.1.tar.bz2
PDO_MYSQL-1.0.2.tgz
libunwind-0.99.tar.gz
ImageMagick.tar.gz
imagick-2.3.0.tgz
google-perftools-1.6.tar.gz
fcgi.conf
php.ini
nginx.conf
php-fpm.conf
EOF
mkdir packages
for i in `cat list`
do
if [ -s packages/$i ]; then
echo "$i [found]"
else
echo "Error: $i not found!!!download now......"
wget http://dev.freeflare.com/packages/$i -P packages/
fi
done
;;

*)

echo -n "exit install script"
exit 0
;;

esac

groupadd www && useradd www -s /sbin/nologin -g www
groupadd mysql && useradd mysql -s /sbin/nologin -g mysql
groupadd hadoop && useradd hadoop -g hadoop
echo "www and mysql user && group created!"

/bin/rm -rf list

echo -e "All of download sucussful!"
}

#system version
function is_version()

{
if [ `uname -m` == "x86_64" ];then
tar zxf libunwind-0.99.tar.gz
tar zxvf libunwind-0.99.tar.gz
cd libunwind-0.99/
CFLAGS=-fPIC ./configure
make CFLAGS=-fPIC
make CFLAGS=-fPIC install
cd ../
else

echo "your system is 32bit ,not install libunwind lib!"
fi
}

function ins_nginx()

{

cd packages

is_version
tar zxf google-perftools-1.6.tar.gz
cd google-perftools-1.6
./configure
make
make install

cd ..
tar zxf pcre-8.10.tar.gz
cd pcre-*
./configure
make
make install
cd ..
tar zxf nginx-1.0.8.tar.gz
cd nginx-1.0.8
#@todo: need todo 
./configure --prefix=${nginx_dir} --with-google_perftools_module --user=www --group=www --with-http_stub_status_module --with-http_flv_module --with-http_ssl_module

make && make install
cd ..
rm -rf /usr/local/nginx/conf/nginx.conf
echo "/usr/local/lib" > /etc/ld.so.conf.d/usr_local_lib.conf
cp nginx.conf /usr/local/nginx/conf/
cp fcgi.conf /usr/local/nginx/conf/
echo "nginx installed sucussfully!"

}

function ins_mysql-server()
{
cd packages/
tar zxf mysql-5.1.52.tar.gz
cd mysql-5.1.52
CHOST="x86_64-pc-linux-gnu"
CFLAGS="-march=nocona -O2 -pipe"
CXXFLAGS="${CFLAGS}"
./configure "--prefix=${mysql_dir}" "--with-server-suffix=-DZWWW" "--with-mysqld-user=mysql" "--without-debug" "--with-charset=utf8" "--with-extra-charsets=all" "--with-pthread" "--with-big-tables" "--enable-thread-safe-client" "--enable-assembler" "--with-readline" "--with-ssl" "--enable-local-infile" "--with-plugins=partition,myisammrg" "--without-ndb-debug"

make && make install
cp support-*/mysql.server /etc/init.d/mysqld
cd /usr/local/mysql
chown -R mysql:mysql .
rm -rf sql-bench mysql-test
echo "mysql server 5.1.52 installed successfully!"
}


function ins_mysql-client()
{

cd packages/
tar zxf mysql-5.1.52.tar.gz
cd mysql-5.1.52
CHOST="x86_64-pc-linux-gnu"
CFLAGS="-march=nocona -O2 -pipe"
CXXFLAGS="${CFLAGS}"
./configure "--prefix=${mysql_dir}" "--with-mysqld-user=mysql" "--without-debug" "--with-charset=utf8" "--with-extra-charsets=all" "--with-pthread" "--with-big-tables" "--enable-thread-safe-client" "--enable-assembler" "--with-readline" "--with-ssl" "--enable-local-infile" "--without-server"

make && make install
cd /usr/local/mysql
chown -R mysql:mysql .
rm -rf sql-bench mysql-test
echo "mysql client 5.1.52 installed successfully!"
}
function ins_php52()
{
cd packages/
tar zxf libiconv-1.13.1.tar.gz
cd libiconv-1.13.1/
./configure --prefix=/usr/local
make
make install
cd ../

tar zxf libmcrypt-2.5.8.tar.gz
cd libmcrypt-2.5.8/
./configure
make
make install
/sbin/ldconfig
cd libltdl/
./configure --enable-ltdl-install
make
make install
cd ../../

tar zxf mhash-0.9.9.9.tar.gz
cd mhash-0.9.9.9/
./configure
make
make install
cd ../

ln -s /usr/local/lib/libmcrypt.la /usr/lib/libmcrypt.la
ln -s /usr/local/lib/libmcrypt.so /usr/lib/libmcrypt.so
ln -s /usr/local/lib/libmcrypt.so.4 /usr/lib/libmcrypt.so.4
ln -s /usr/local/lib/libmcrypt.so.4.4.8 /usr/lib/libmcrypt.so.4.4.8
ln -s /usr/local/lib/libmhash.a /usr/lib/libmhash.a
ln -s /usr/local/lib/libmhash.la /usr/lib/libmhash.la
ln -s /usr/local/lib/libmhash.so /usr/lib/libmhash.so
ln -s /usr/local/lib/libmhash.so.2 /usr/lib/libmhash.so.2
ln -s /usr/local/lib/libmhash.so.2.0.1 /usr/lib/libmhash.so.2.0.1
ln -s /usr/local/bin/libmcrypt-config /usr/bin/libmcrypt-config

tar zxf mcrypt-2.6.8.tar.gz
cd mcrypt-2.6.8/
/sbin/ldconfig
./configure
make
make install
cd ../
tar zxf php-5.2.17.tar.gz
gzip -cd php-5.2.17-fpm-0.5.14.diff.gz | patch -d php-5.2.17 -p1
cd php-5.2.17/
./configure --prefix=${php_dir} --with-config-file-path=${php_dir}/etc --with-mysql=${mysql_dir} --with-mysqli=${mysql_dir}/bin/mysql_config --with-iconv-dir=/usr/local --with-freetype-dir --with-jpeg-dir --with-png-dir --with-zlib --with-libxml-dir=/usr --enable-xml --disable-rpath --enable-discard-path --enable-safe-mode --enable-bcmath --enable-shmop --enable-sysvsem --enable-inline-optimization --with-curl --with-curlwrappers --enable-mbregex --enable-fastcgi --enable-fpm --enable-force-cgi-redirect --enable-mbstring --with-mcrypt --with-gd --enable-gd-native-ttf --with-openssl --with-mhash --enable-pcntl --enable-sockets --with-ldap --with-ldap-sasl --with-xmlrpc --enable-zip --enable-soap
make ZEND_EXTRA_LIBS='-liconv'
make install
cd ..
cp php.ini /usr/local/php52/etc/
cp php-fpm.conf /usr/local/php52/etc/

echo "/usr/local/mysql/lib/mysql" >> /etc/ld.so.conf.d/mysql_lib.conf
/sbin/ldconfig
echo "php52 installed successfully!"
}

function ins_php52-ext()
{
cd packages/

tar zxf memcache-2.2.5.tgz
cd memcache-2.2.5/
${php_dir}/bin/phpize
./configure --with-php-config=${php_dir}/bin/php-config
make
make install
cd ../

tar jxf eaccelerator-0.9.6.1.tar.bz2
cd eaccelerator-0.9.6.1/
${php_dir}/bin/phpize
./configure --enable-eaccelerator=shared --with-php-config=${php_dir}/bin/php-config
make
make install
cd ../

tar zxf PDO_MYSQL-1.0.2.tgz
cd PDO_MYSQL-1.0.2/
${php_dir}/bin/phpize
./configure --with-php-config=${php_dir}/bin/php-config --with-pdo-mysql=${mysql_dir}
make
make install
cd ../

tar zxf ImageMagick.tar.gz
cd ImageMagick-6.5.1-2/
./configure
make
make install
cd ../

tar zxf imagick-2.3.0.tgz
cd imagick-2.3.0/
${php_dir}/bin/phpize
./configure --with-php-config=${php_dir}/bin/php-config
make
make install
cd ../
echo "php52 extension installed successfully!"
}

case $1 in
init)

init
;;
ins_mysql-server)

ins_mysql-server

;;
ins_mysql-client)
ins_mysql-client
;;
ins_nginx)
ins_nginx
;;
ins_php52)
ins_php52
;;
ins_php52-ext)
ins_php52-ext
;;
*)


echo "Usage:`basename $0` {init|ins_mysql-server|ins_mysql-client|ins_php52|ins_php52-ext|ins_mysql}"
;;
esac
