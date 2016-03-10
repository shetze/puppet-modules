class git::client (
  $gitpackage     = 'git',
  $package_ensure = 'installed',
){
  package { "$gitpackage":
    ensure => $package_ensure,
}
}
