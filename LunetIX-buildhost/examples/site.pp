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
$jenkins_ssh_pub_key='AAAAB3NzaC1yc2EAAAADAQABAAABAQC2TdsQdyMf+m9Kvf2MqRBWr9ti3V17NVB+7aIOKmyBYUosxf4laUuIbJ2g5DLujEv9cGFczHSBLoPwO0PO83o1Cz2e3+aKV03M5ghic4Rp2j9dKNbrRrDBc4pPZT7uEI0ah1U6sF7vQqyL+teCzjxS3mFIkYVKsqM0SSr888ErYUvC+bl4XpAr2J40kdJ5YR2kH+DLIxor7TyMk8bNqmkUqks554GXEI5PsZ8faE82PaqY/iEfPaiddiloVUkz2QWtd4SCtWUylNHRyGoK7Tp97RqZG8KG53nCyTk0N5MPuKS45UEeJVxK3pUwpnrmHuLluiYrfdSV04r6WlI8YjX/'
$jenkins_ssh_priv_key='-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEAtk3bEHcjH/pvSr39jKkQVq/bYt1dezVQfu2iDipsgWFKLMX+
JWlLiGydoOQy7oxL/XBhXMx0gS6D8DtDzvN6NQs9nt/mildNzOYIYnOEado/XSjW
60awwXOKT2U+7hCNGodVOrBe70Ksi/rXgs48Ut5hSJGFSrKjNEkq/PPBK2FLwvm5
eF6QK9ieNJHSeWEdpB/gyyMaK+08jJPGzappFKpLOeeBlxCOT7GfH2hPNj2qmP4h
Hz2onXYpaFVJM9kFrXeEgrVlMpTR0chqCu06fe0amRvChud5wsk5NDeTD7ikuOVB
HiVcSt6VMKZ65h7i5bomK33UldOK+lpSPGI1/wIDAQABAoIBAEdqHlvH3+miCEDm
RlH41J6wyydigkFGtF7UpjwYYGMagp0hfpqXMfCiY+loG4+ZRBdnE6zvpuAIIcVU
4g5LEN+ApMX8/enJo3+VyUkP6Zox1cqfufl2ur09jrvldI57y1rOExQnjTj7DG7V
d+EU+0qXNNLhtq55ZjeQRhfLQSvFizq++AyE9o11LqhuJUX9dxwjPeNCn+fxVdJj
Krzsbg6RSW4/v6S1fFV64Ib7tSG93XAwaekEXbZzaljSOMMjZ4N84QekliR5oZgP
s60JeIv+pHs2ueoaZQZgTuK/SUndYVm0WSsTS5LchP5k/80zfwUQxyEd1qYlKysC
3ZTD7aECgYEA3tb3//1wSVdprGMXC6Bt6YaKJvk0hfI5/EymYZCq6Gt8oS4S1u0m
hfujkY2tCsfGWiNA3VXbL7T+Ii8oi5cLQgUt4QpXwayiRJnjGd0H9I/MbY9kb5Qe
L0KEZib6xe6hEDkdTMOnEAPVxA6Hl8ZTLvWsHIfXiT/rVkVJ9qfS3DECgYEA0W6x
LSAjuTq5bljYdmpbpQ62uLVMaOc7ommeWYA29vGO/Jr9nvZnn7ynjiJRHmzmi5nJ
um8b/Go3tCNNLB+wWgUKC3LOMy7Wj44EaDu5hadgo4bJkhmaPnAPzZEZip4PHz4f
DrGzNejhyidvgV72bcg6/M6RSVn1E3hi91wbGS8CgYEAum8DgYpZ3SJi6LTmXPXV
vyCuiLjJ9p6XYLwIH2xXcKgs1vSjEmnKZyIG0QnFElXdXyBLbmIcRSeZzqPBujee
VZfbsIFktkZmZBqTY9oGg9ei4q6rCqbTMhrmhkhqWhqxac8+8jBmnwF2YNb/Hj3w
7kLfwebsrolprP2/SbtSsKECgYBe4A9hivLEAcdpJtSA6HO11XGPQYpo53/Ldp9m
mj/MJOgKpUgJ0ERnR7Z8HC21Y84ZJcUOMTFzasbrUyatu3lPfoLrZsnkw+4tQD/c
3FmSI54S1ofQKMsISAnQrU/tzOa615CIPpYZ8PMAelb4O4XVe+TFC+sjWJ4+gMYM
muwnvwKBgQC1wPwKUUOrGfjjpXU6U2eC4sXXv8Uzeh77AzOu8srme3SFEu7EtrRP
yc7m7UQkFRlIdgKF5USyhrvHRhcPKfPwvDzbXXSHfxi91wTTWGYlmAZu9WYGfqH6
7SEVVOYbE1plR14i5jEjFfGrsHhvm5SCR5CtAQH569mJ7fK3QgEjfw==
-----END RSA PRIVATE KEY-----'
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
