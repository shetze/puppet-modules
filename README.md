The puppet modules in this repo create a simple but powerful CI infrastructure for and with Red Hat Satellite-6.
The basic idea of this project is to use Satellite-6 to automatically create a build host that builds all parts required to re-create this build host (and potentially any other component you can think of).
git, jenkins and mock are cornerstones of this automation. nexus and sonar are added mainly to make the ticket-monster demo more colorful and to give mock something real to build.

git is a basic module to setup a local git server. The server autmatically builds modules and makes them available via HTTP for later sync into Satellite. Puppet configuration includes opening firewall ports to access the git server and tuning SELinux rules to allow ssh access to git.

buildhost is a comprehensive host profile to create this fairly sophisticated CI automation build host.
It uses the git module above, rtyler/jenkins and puppetlabs/postgresql to provide configuration classes for jenkins, nexus, sonar, hammer and mock. This module lays the foundation for an automated, self replicating build environment.

dockerhost provides a host profile for a container host that is used as staging infrastructure in the demo setup included in the buildhost module above.


To bootstrap this infrastructure you first need to clone this repo, build the puppet modules, load them into the Satellite and create a Content View with the git and buildhost modules from this repo and camptocamp/archive, puppetlabs/concat, puppetlabs/java, rtyler/jenkins, puppetlabs/postgresql and puppetlabs/stdlib to resolve the dependencies.

A r10k control setup is provided for convenience to automate development of the git module and the buildhost profile.

Futher you need EPEL, apache-maven and jenkins products synced into your Satellite. (The http://pkg.jenkins-ci.org/redhat-stable/ repo is quite large so I prefer to manually upload current packages into my Jenkins product.)
Add these products / repos to your Content View and create a host using the buildhost puppet class.
This leads to a basic build host capable to create puppet modules for smoke tests.

The puppet module build is triggerd autmatically by git commits, so you may want to mirror these upstream modules into your own buildhost git. As prereq you need to add your ssh key to the git authorized_keys. Then you do:

~~~
git clone --mirror https://github.com/shetze/puppet-modules.git
cd puppet-modules.git
git remote set-url --push origin git@your.git.host:puppet-modules.git
git push --mirror
~~~
To merge upstream modifications, return to the mirror clone and do:
~~~
git fetch -p origin
git push --mirror
~~~


TBC
