class shop::oxid (
  $db_host = localhost,
) {

  include stdlib

  ensure_packages(['firewalld', 'httpd', 'php', 'php-mysql', 'php-xml', 'php-gd', 'php-soap', 'php-mbstring', 'php-bcmath', 'oxid', ])
  
  service { 'httpd':
    ensure  => 'running',
    enable  => true,
  }

  exec { 'firewalld_prepare_oxid':
    require => [ Package['firewalld'], ],
    command => "firewall-cmd --permanent --add-service=http --add-service=https &&
                firewall-cmd  --complete-reload",
    unless  => 'firewall-cmd --list-all|grep -q https',
    path    => [ '/usr/sbin/','/usr/bin/', ],
  }

  exec { 'selinux_prepare_oxid':
    command => 'semanage fcontext -a -t httpd_sys_rw_content_t "/var/www/html/oxid/log(/.*)?" &&
      semanage fcontext -a -t httpd_sys_rw_content_t "/var/www/html/oxid/tmp(/.*)?" &&
      semanage fcontext -a -t httpd_sys_rw_content_t "/var/www/html/oxid/export(/.*)?" &&
      semanage fcontext -a -t httpd_sys_rw_content_t "/var/www/html/oxid/out/pictures(/.*)?" &&
      semanage fcontext -a -t httpd_sys_rw_content_t "/var/www/html/oxid/out/media(/.*)?" &&
      semanage fcontext -a -t httpd_sys_rw_content_t "/var/www/html/oxid/.htaccess" &&
      semanage fcontext -a -t httpd_sys_rw_content_t "/var/www/html/oxid/config.inc.php" &&
      restorecon -R /var/www/html/oxid',
    unless => 'ls -Z /var/www/html/oxid/.htaccess|grep -q httpd_sys_rw_content_t',
    path    => ['/usr/bin/', '/usr/sbin/', ],
  }
  
}
