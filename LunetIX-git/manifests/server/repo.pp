class git::server::repo (
  $repo = undef,
){
  exec { "git_init_$repo":
    command => "git init --bare ${git_repodir}/${repo}.git",
    path => [ '/bin/', '/usr/bin/' ],
    unless => "test -d ${git_repodir}/${repo}.git/objects",
    require => [ Package["$gitpackage"], File["$git_repodir"], Exec["selinux_prepare_git"] ],
  }
}
