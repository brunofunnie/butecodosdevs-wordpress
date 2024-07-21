sed -i s/'user = www-data'/'user = wordpress'/g /usr/local/etc/php-fpm.d/www.conf
sed -i s/'group = www-data'/'group = wordpress'/g /usr/local/etc/php-fpm.d/www.conf

php-fpm
