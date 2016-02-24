class git::server (
  $git_puppet_project = 'puppet-modules',
  $git_repobase =  '/srv/git',
  $git_user = 'git',
  $git_group = 'git',
  $git_package = 'git',
  $package_ensure = 'installed',
){

package { "$git_package":
    ensure => $package_ensure,
}

user { $git_user:
    ensure => present,
    purge_ssh_keys => false,
}

package { "httpd":
    ensure => $package_ensure,
}

package { "policycoreutils-python":
    ensure => $package_ensure,
}

service { "httpd":
    ensure => "running",
    require => Package["httpd"],
}

file { "/var/www/html/$git_puppet_project":
    ensure => directory,
    owner => $git_user,
    group => $git_group,
    mode => "775",
}

file { "$git_repobase":
    ensure => directory,
    owner => $git_user,
    group => $git_group,
    mode => "700",
}

file { "$git_repobase/.ssh":
    ensure => directory,
    owner => $git_user,
    group => $git_group,
    mode => "700",
}

exec { "selinux_prepare_git":
    require => [ Package["$git_package"], Package['policycoreutils-python'], File["$git_repobase"] ],
    command => "semanage fcontext -a -t ssh_home_t '/var/www/git/.ssh/authorized_keys' &&
		semanage fcontext -a -e /var/www/git $git_repobase &&
		restorecon -R $git_repobase",
    unless => "ls -Zd $git_repobase/|grep -q git_content_t",
    path => [ "/usr/bin/", "/usr/sbin/" ],
}

}
