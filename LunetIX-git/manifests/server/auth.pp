class git::server::auth (
  $key = undef,
  $user = undef,
){
  exec { '$user_permit_git':
    require => [ ],
    command => "echo $key >> $::git::git_repodir/.ssh/authorized_keys",
    unless => "grep -q $user $::git::git_repodir/.ssh/authorized_keys",
    path => [ "/usr/bin/", "/usr/sbin/" ],
  }
}
