class git::server (
  $repo = 'puppet-modules',
  $repodir =  '/srv/git',
  $gituser = 'git',
  $gitgroup = 'git',
  $gitpackage = 'git19-git',
  $package_ensure = 'installed',
){

exec { "rhscl_activate_git":
    require => Package["$gitpackage"],
    command => "scl enable git19 bash",
    unless => "test -f /etc/profile.d/sclgit.sh",
    path => "/usr/bin/",
}

file { "/etc/profile.d/sclgit.sh":
    ensure => file,
    mode => "644",
    owner => "root",
    group => "root",
    source => "puppet:///modules/git/sclgit.sh",
}

package { "$gitpackage":
    ensure => $package_ensure,
}

package { "httpd":
    ensure => $package_ensure,
}

package { "pulp-puppet-tools":
    ensure => $package_ensure,
}

package { "python-pulp-puppet-common":
    ensure => $package_ensure,
}

service { "httpd":
    ensure => "running",
    require => Package["httpd"],
}

file { "/var/www/html/$repo":
    ensure => directory,
    owner => $gituser,
    group => $gitgroup,
    mode => "775",
}

file { "$repodir":
    ensure => directory,
    owner => $gituser,
    group => $gitgroup,
    mode => "775",
}

exec { "git_init_bare":
    command => "git init --bare ${repodir}/${repo}.git",
    path => [ '/opt/rh/git19/root/usr/bin/', '/usr/bin/' ],
    unless => "test -d ${repodir}/${repo}.git/objects",
    require => [ Package["$gitpackage"], File["$repodir"], Exec["rhscl_activate_git"] ],
    before => File["${repodir}/${repo}.git/hooks/post-receive"],
}

file { "${repodir}/${repo}.git/hooks/post-receive":
    ensure => file,
    owner => $gituser,
    group => $gitgroup,
    mode => "755",
    source => "puppet:///modules/git/post-receive",
}
}
