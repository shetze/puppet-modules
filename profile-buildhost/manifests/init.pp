# == Class: buildhost
#
# Full description of class buildhost here.
#
# === Parameters
#
# Document parameters here.
#
# [*ci_build_host*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# [*ci_git_host*]
#
# [*ci_dockerhost_test*]
#
# [*ci_dockerhost_prod*]
#
# [*ci_yum_repo_id*]
#
# [*ci_puppet_repo_id*]
#
# [*ci_template_instance*]
#
# [*ci_target_env*]
#
# [*ci_content_view*]
#
# [*deploy_ci_pipeline*]
#
# [*deploy_demo*]
#
# [*git_repobase*]
#
# [*create_jenkins_repo*]
#
# [*hammer_user*]
#
# [*hammer_passwd*]
#
# [*mock_entitlement_path*]
#
# [*sonar_database_host*]
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { buildhost:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Sebastian Hetze <shetze@redhat.com>
#
# === Copyright
#
# Copyright 2016 Sebastian Hetze
#
class buildhost (
  $ci_build_host         = 'localhost',
  $ci_git_host           = 'bx-bld-dev01.lunetix.org',
  $ci_dockerhost_test    = 'bx-dh01.lunetix.org',
  $ci_dockerhost_prod    = 'bx-dh01.lunetix.org',
  $ci_yum_repo_id        = 160,
  $ci_puppet_repo_id     = 190,
  $ci_template_instance  = 'rhel7-baseline.lunetix.org',
  $ci_target_env         = 1,
  $ci_content_view       = 'bl-dev-rhel7',
  $deploy_ci_pipeline    = true,
  $deploy_demo           = true,
  $deploy_baseline       = false,
  $deploy_git            = true,
  $git_repobase          = '/srv/git',
  $git_puppet_project    = 'puppet-modules',
  $git_sync_product      = 'LunetIX',
  $git_sync_repo         = 'LunetIX Puppet Modules',
  $git_sync_cv           = 'puppet-library',
  $create_jenkins_repo   = false,
  $hammer_user           = 'jenkins',
  $hammer_passwd         = 'OhjahNg2',
  $mock_entitlement_path = '/etc/pki/entitlement',
  $mock_extra_packages   = '',
  $sonar_database_host   = 'localhost',
  $jenkins_ssh_priv_key  = "-----BEGIN RSA PRIVATE KEY-----
MIIEpQIBAAKCAQEAuSeSfsa8b25oJTaVqLNe0q8tuex2FehByUT5fdB8Ee1k0FpN
Pg2OyRJAyyakPlcPyQr8ubYMiAwl+G573sK/i5f8UElFTXIARXjsRGXkjrtx2Lct
hnmMPZpe4X59sFCYTSxZonUgpevGirEnFbKIQtFP7I/kT035E9pFkzifWS8zeZQX
1mhm4IUiaDojIKxNRWhs//GJ8C8Re3tPUfs8IKxvS5D7thW7lDcXQwFiIlWNQrdW
JjVONfuhKU+lRqqp5rD52Qh2ay02v1/2+ybwzPNQBCTGEmLPH0QXO/jnEuRQcLuV
+ZrcD4NU29AtnV4QlEhnsd0EZYNrfDLsxFvSvQIDAQABAoIBAQCASUrXTBuDmZvP
LOLE4ILyty2XhJ7Mzv/F1GSJJ8rPIQyYz/h05i/oYR1DpKJoDyqAwXwZsGk+Wix0
1Rg+X/EXZ1cKybmaz0Ig4IfTXEXgHz/iSAjjA5SHmk3jLyEm6LCdx/zS8xSL4bDO
p6/M+MYwhZY68ffeesf5WWKbfr/pqfwt5ihmhRsA9Z152OhK7AfGQj5ssqaChX2L
WZ9RhoP4rzgiOkdm/mdElQQdXNUGv+pbVGcectMb0K5tQGCIhrOXjiWBOxGV9GFE
1BKuGfWLsfpuUuZf5uVsH0E+BXwf/ZsJObIj3aSVr+vAckVt69sGFY5SUm3xDLAg
mWuj16qBAoGBAOmg+27SKI28kwXKZIpj4D5gTa/RVLItRgsisua3cHKJlgA/uHaQ
X5mJUI8q7axhG0ifsq0/81uUcxqL61GgVcnWAyJYarV1E+7BanUiOT6Mm8rNTjeo
/B3IX6mQVwx7/icS3FsQ2bHf4w/mbSvYSZXm8xYp82QsIcMKzdjyl0C/AoGBAMri
U0HuhjLzJEY0K0dZ/7rm2iBSmSBYwyN6Y3/+dKgJ5lmo4MO98ZZjrrx9R+zCX1X7
mxtaS2kTte5ciq0VD8zzn5sowQH+LvrQvIvB8gFrPJrcjv9sCE8XAFEANL1VFdFJ
6P+RhzS4nv+W3RxJ8ZwhyKo/YlFdrIVeZekT9Y+DAoGAbPsOLozUJAHCJ2JY8gFS
+mXb91bThmX+FXWzNFJ/nr41fZo7xvrjzXAzZwVkZxPJMWBlbdG2CJM/+jMoqyP6
wLMXNS8/X7Pkf2wz5732LApVJg4NHYOzT4VHsoZFROqWDM4MgmJi2kmQ1rrrVBeJ
g+Z+oGkjQyge+6ePjFLlYWsCgYEAhC5UZB5NHKDAv2R51fDS5ihFcM2fqi1qZZD1
hox34IsiosOePKlh3sNvMqrE04IHrvNQKM/5Vapb28I7L20LcFJBaEtzBCNg5FRe
owdm7nm5cIPGPq9Z8n1f3WYu9jObFVH8FZXw6u5l2Munnyil2z0/iXvmSHCpV/Ma
nnI8iJUCgYEAwlXiwXzpiQgCylqql8bfK7Wm/sJbUnspNyCl55RqWWOEwAxAVxf7
bL9/83AoUGJ6X8vz2yyIjdNBQzmZ3oeeZPClsNi/z1j8YqAsV+NGzc4RRUVr5Nte
GzOlH77KKeXAikTnTX5uDWHI31G39yf4R1rOqgMLBacSTj1+LNGMfxY=
-----END RSA PRIVATE KEY-----",
  $jenkins_ssh_pub_key   = 'AAAAB3NzaC1yc2EAAAADAQABAAABAQC5J5J+xrxvbmglNpWos17Sry257HYV6EHJRPl90HwR7WTQWk0+DY7JEkDLJqQ+Vw/JCvy5tgyIDCX4bnvewr+Ll/xQSUVNcgBFeOxEZeSOu3HYty2GeYw9ml7hfn2wUJhNLFmidSCl68aKsScVsohC0U/sj+RPTfkT2kWTOJ9ZLzN5lBfWaGbghSJoOiMgrE1FaGz/8YnwLxF7e09R+zwgrG9LkPu2FbuUNxdDAWIiVY1Ct1YmNU41+6EpT6VGqqnmsPnZCHZrLTa/X/b7JvDM81AEJMYSYs8fRBc7+OcS5FBwu5X5mtwPg1Tb0C2dXhCUSGex3QRlg2t8MuzEW9K9',
  $jenkins_user = 'jenkins',
  $maven_package_ensure  = true,
) {

  if $deploy_git {
    class { '::buildhost::git':
      jenkins_ssh_pub_key => $jenkins_ssh_pub_key,
      jenkins_user        => $jenkins_user,
      hammer_user         => $hammer_user,
      hammer_passwd       => $hammer_passwd,
      git_repobase        => $git_repobase,
      git_host            => $ci_git_host,
      git_user            => 'git',
      git_group           => 'git',
      git_puppet_project  => $git_puppet_project,
      git_sync_product    => $git_sync_product,
      git_sync_repo       => $git_sync_repo,
      git_sync_cv         => $git_sync_cv,
    }
  }

  class { '::buildhost::jenkins':
    jenkins_ssh_priv_key  =>   $jenkins_ssh_priv_key,
    maven_package_ensure  =>   $maven_package_ensure,
    git_repobase          =>   $git_repobase,
    create_jenkins_repo   =>   $create_jenkins_repo,
    deploy_demo           =>   $deploy_demo,
    deploy_baseline       =>   $deploy_baseline,
    ci_yum_repo_id        =>   $ci_yum_repo_id,
    ci_puppet_repo_id     =>   $ci_puppet_repo_id,
    ci_target_env         =>   $ci_target_env,
    ci_content_view       =>   $ci_content_view,
    ci_template_instance  =>   $ci_template_instance,
    ci_git_host           =>   $ci_git_host,
    ci_build_host         =>   $ci_build_host,
    ci_dockerhost_test    =>   $ci_dockerhost_test,
    ci_dockerhost_prod    =>   $ci_dockerhost_prod,
    deploy_ci_pipeline    =>   $deploy_ci_pipeline,
    mock_entitlement_path =>   $mock_entitlement_path,
    mock_extra_packages   =>   $mock_extra_packages,
    sonar_database_host   =>   $sonar_database_host,
  }
  class { '::buildhost::hammer':
    hammer_user   => $hammer_user,
    hammer_passwd => $hammer_passwd,
  }
  class { '::buildhost::mock':
    mock_extra_packages   => $mock_extra_packages,
    mock_entitlement_path => $mock_entitlement_path,
  }

  if $deploy_demo {
    include buildhost::nexus
    class { '::buildhost::sonar':
      sonar_database_host => $sonar_database_host,
    }
  }
}
