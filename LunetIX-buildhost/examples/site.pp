$ci_build_host = 'bx-bld-dev01.lunetix.org'
$ci_git_host = 'bx-builder.lunetix.org'
$ci_dockerhost_test = 'bx-dh01.lunetix.org'
$ci_dockerhost_prod = 'bx-dh01.lunetix.org'
$ci_yum_repo_id = 160
$ci_puppet_repo_id = 190
$ci_template_instance = 'rhel7-baseline.lunetix.org'
$ci_target_env = 1
$ci_content_view = 'bl-dev-rhel7'
$rhsm_organization_label = 'LunetIX'
$foreman_url = 'bx-sat.lunetix.org'
$templates = '/etc/puppet/modules/buildhost/templates'
$deploy_demo = false
$repodir = '/srv/git'
$create_jenkins_repo = false
$hammer_user = 'jenkins'
$hammer_passwd = 'OhjahNg2'
$mock_entitlement_path = '/etc/pki/entitlement'
$mock_rhel6_repos = ""
$mock_rhel7_repos = "[rhel-7-server-rpms]
name = Red Hat Enterprise Linux 7 Server (RPMs)
baseurl=https://bx-sat.lunetix.org/pulp/repos/LunetIX/development/inf-builder-rhel7/content/dist/rhel/server/7/7Server/\$basearch/os
enabled = 1
gpgcheck = 1
gpgkey = file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release
sslverify = 1
sslcacert = /etc/rhsm/ca/katello-server-ca.pem
sslclientkey = /etc/pki/entitlement/4934450955046494099-key.pem
sslclientcert = /etc/pki/entitlement/4934450955046494099.pem
metadata_expire = 86400
ui_repoid_vars = basearch releasever
[epel]
name=Extra Packages for Enterprise Linux 7 - \$basearch
metadata_expire = 1
baseurl = https://bx-sat.lunetix.org/pulp/repos/LunetIX/development/inf-builder-rhel7/custom/Extra_Packages_for_Enterprise_Linux/EPEL_7_-_x86_64
sslverify = 1
name = EPEL 7 - x86_64
sslclientkey = /etc/pki/entitlement/1705004534509240851-key.pem
sslclientcert = /etc/pki/entitlement/1705004534509240851.pem
gpgkey = https://bx-sat.lunetix.org/katello/api/repositories/20/gpg_key_content
enabled = 1
sslcacert = /etc/rhsm/ca/katello-server-ca.pem
gpgcheck = 1"

include git::server
include buildhost::jenkins
include buildhost::nexus
include buildhost::sonar
include buildhost::mock
include buildhost::hammer
