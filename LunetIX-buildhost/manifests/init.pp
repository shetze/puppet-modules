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
# [*git_repodir*]
#
# [*create_jenkins_repo*]
#
# [*hammer_user*]
#
# [*hammer_passwd*]
#
# [*mock_entitlement_path*]
#
# [*mock_rhel6_repos*]
#
# [*mock_rhel7_repos*]
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
# Copyright 2015 Sebastian Hetze
#
class buildhost (
  $ci_build_host = 'bx-bld-dev01.lunetix.org',
  $ci_git_host = 'bx-builder.lunetix.org',
  $ci_dockerhost_test = 'bx-dh01.lunetix.org',
  $ci_dockerhost_prod = 'bx-dh01.lunetix.org',
  $ci_yum_repo_id = 160,
  $ci_puppet_repo_id = 190,
  $ci_template_instance = 'rhel7-baseline.lunetix.org',
  $ci_target_env = 1,
  $ci_content_view = 'bl-dev-rhel7',
  $deploy_ci_pipeline = true,
  $deploy_demo = false,
  $git_repodir = '/srv/git',
  $create_jenkins_repo = false,
  $hammer_user = 'jenkins',
  $hammer_passwd = 'OhjahNg2',
  $mock_entitlement_path = '/etc/pki/entitlement',
  $mock_rhel6_repos = "",
  $mock_rhel7_repos = "",
  $sonar_database_host = "localhost",
){

include git::server
include buildhost::jenkins
include buildhost::mock
include buildhost::hammer
if $deploy_demo {
  include buildhost::nexus
  include buildhost::sonar
}
class{ '::git': git_repodir => $git_repodir }

}
