define git::server::allow (
  $allow_user = undef,
  $public_key = undef,
  $git_repodir =  '/srv/git',
  $gituser = 'git',
){

user { $gituser:
    ensure => present,
    purge_ssh_keys => false,
}

file { "$git_repodir/.ssh":
    ensure => directory,
    owner => $gituser,
    group => $gitgroup,
    mode => "700",
}

ssh_authorized_key { "${allow_user}":
    user    => $gituser,
    target  => "/srv/$gituser/.ssh/authorized_keys",
    type    => 'rsa',
    ensure  => present,
    key     => "$public_key",
    require => File["$git_repodir/.ssh"],
}
}
