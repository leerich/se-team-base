class offline_repo {

  $sefiles = $virtual ? {
    'virtualbox' => '/var/seteam-files',
    default      => '/opt/seteam-files',
  }

  file { $sefiles:
    ensure => directory,
  }


  package { 'yum-plugin-downloadonly':
    ensure => present,
  }
  package { 'createrepo':
    ensure => present,
  }

  file { "${sefiles}/rpm":
    ensure => directory,
  }

  exec { 'yum_download':
    command => "/usr/bin/yum -y install tomcat6-docs-webapp tomcat6-webapps tomcat6 fontconfig dejavu-fonts-common java java-1.7.0-openjdk java-1.7.0-openjdk-devel tomcat6-admin-webapps --downloadonly --downloaddir=${sefiles}/rpms",
    require => [
      Package['yum-plugin-downloadonly'],
      Package['createrepo'],
      File["${sefiles}/rpms"],
    ],
    returns => [ '0','1'],
  }

  exec { 'createrepo':
    command => "/usr/bin/createrepo ${sefiles}/rpms",
    require => Exec['yum_download'],
  }
}

include offline_repo
