define git::server::allow (
  $allow_user = undef,
  $public_key = undef,
  $git_repodir =  '/srv/git',
  $gituser = 'git',
){

ssh_authorized_key { "${allow_user}":
    user    => $gituser,
    target  => "/srv/$gituser/.ssh/authorized_keys",
    type    => 'rsa',
    ensure  => present,
    key     => "$public_key",
}
}
