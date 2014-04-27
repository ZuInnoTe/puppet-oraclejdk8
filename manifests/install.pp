# == Class: oraclejdk8::install
#
# Puppet module for the installation of Oracle JDK 8
#
# === Examples
# Installation:
# oraclejdk8::install{oraclejdk8-local:}
#
# === Authors
#
# Jörn Franke jornfranke@gmail.com
#
# === Copyright
#
# Copyright 2014 Jörn Franke
define oraclejdk8::install(
  $set_default_env      = true
) {

include apt

# do a fully automated installation

exec { "auto_accept_license":
    command => "echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections", 
    path => "/bin:/usr/bin",
    before => Package["oracle-java8-installer"]
}


# include repository for Oracle JDK8
case $operatingsystem {
      debian: { 
	 apt::source { 'debian_oraclejdk8':
  	 	location          => 'http://ppa.launchpad.net/webupd8team/java/ubuntu',
  	 	release           => 'trusty',
  	 	repos             => 'main',
  	 	required_packages => 'debian-keyring debian-archive-keyring',
  	 	key               => 'EEA14886',
 	 	key_server        => 'keyserver.ubuntu.com',
  	 	include_src       => true,
		before => Package["oracle-java8-installer"]
      	 }
      }
      ubuntu: { apt::ppa { ' ppa:webupd8team/java': before => Package["oracle-java8-installer"]} }
      default: { fail("Installation only supported for Ubuntu or Debian") }
}



# start the Oracle JDK8 installer (needs internet connection)
package { "oracle-java8-installer": 
	ensure => "installed" 
}

# execute smoke tests after the installation
exec { "smoketest_java": 
	command => "java -version 2>&1 | grep 1.8", 
	path => "/bin:/usr/bin",
	returns => 0,
	require => Package["oracle-java8-installer"]
}
exec { "smoketest_javac": 
	command => "javac -version 2>&1 | grep 1.8", 
	path => "/bin:/usr/bin",
	returns => 0,
	require => Package["oracle-java8-installer"]
}

# sets default environment variables
if $set_default_env {
	package { "oracle-java8-set-default": ensure => "installed", require => Package["oracle-java8-installer"]}
}
else {
  # do not do anything
}

}
