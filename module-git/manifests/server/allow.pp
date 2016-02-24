define git::server::allow (
  $allow_user = undef,
  $public_key = undef,
  $git_repobase =  '/srv/git',
  $git_user = 'git',
){

ssh_authorized_key { "${allow_user}":
    user    => $git_user,
    target  => "$git_repobase/.ssh/authorized_keys",
    type    => 'rsa',
    ensure  => present,
    key     => "$public_key",
}
}
