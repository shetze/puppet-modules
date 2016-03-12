class git::server (
  $git_puppet_project = 'puppet-modules',
  $git_repobase       = '/srv/git',
  $git_user           = 'git',
  $git_group          = 'git',
  $git_package        = 'git',
  $package_ensure     = 'installed',
){

include stdlib
ensure_packages(["$git_package","httpd","policycoreutils-python",'firewalld',])

user { $git_user:
    ensure         => present,
    purge_ssh_keys => false,
}

service { 'httpd':
    ensure  => 'running',
    require => Package['httpd'],
}


exec { 'firewalld_prepare_httpd':
    require => [ Package['firewalld'], ],
    command => "firewall-cmd --permanent --add-port=80/tcp &&
                firewall-cmd  --complete-reload",
    unless  => 'firewall-cmd --list-all|grep -q [[:space:]]80/',
    path    => '/usr/bin/',
}

file { "/var/www/html/$git_puppet_project":
    ensure => directory,
    owner  => $git_user,
    group  => $git_group,
    mode   => "775",
}

file { "$git_repobase":
    ensure  => directory,
    owner   => $git_user,
    group   => $git_group,
    seltype => 'git_content_t',
    mode    => '700',
}

file { "$git_repobase/.ssh":
    ensure  => directory,
    owner   => $git_user,
    group   => $git_group,
    mode    => "700",
    seltype => 'ssh_home_t',
    require =>  [ File["$git_repobase"], Exec['selinux_prepare_git'] ],
}

file { "$git_repobase/.ssh/authorized_keys":
    ensure  => file,
    owner   => $git_user,
    group   => $git_group,
    mode    => "600",
    seltype => 'ssh_home_t',
    require =>  [ File["$git_repobase/.ssh"] ],
}

exec { 'selinux_prepare_git':
    command => "semanage fcontext -a -t ssh_home_t '/var/www/git/.ssh' &&
                semanage fcontext -a -t ssh_home_t '/var/www/git/.ssh/authorized_keys' &&
                semanage fcontext -a -t user_home_t '/var/www/git/.hammer' &&
                semanage fcontext -a -t user_home_t '/var/www/git/.hammer/cli_config.yml' &&
		semanage fcontext -a -e /var/www/git $git_repobase &&
		restorecon -R $git_repobase",
    unless  => "ls -Zd $git_repobase|grep -q git_content_t",
    path    => [ "/usr/bin/", "/usr/sbin/" ],
    require => [ Package["$git_package"], Package['policycoreutils-python'], File["$git_repobase"] ],
}

}
