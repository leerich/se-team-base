# class installs / configures ldap service
class ldap (
  $ldap_host = $::fqdn,
  $ldap_user = 'uid=admin,ou=system',
  $ldap_pass = 'secret',
  $ldif_folder = '/etc/ldap-demo/ldif',
  $ldap_pkg = 'ldap-demo-0.1.3-1.el6.noarch.rpm',
  $ldap_pkg_baseurl = 'https://s3.amazonaws.com/saleseng/files',
) {
  include profile::staging
  include ldap::reqs
  contain java

  staging::file { 'ldap-demo.rpm':
    source => "${ldap_pkg_baseurl}/${ldap_pkg}",
  }
  
  package { 'ldap-demo':
    ensure   => latest,
    source   => '/var/staging/ldap/ldap-demo.rpm',
    require  => [
      Class['java'],
      Staging::File['ldap-demo.rpm']
    ],
    before   => File['/etc/ldap-demo/conf.d/ldap.conf'],
    notify   => Service['ldap-demo'],
    provider => rpm,
  }

  file { '/etc/ldap-demo/conf.d/ldap.conf':
    ensure  => file,
    content => template('ldap/ldap.erb'),
  }

  file { "$ldif_folder":
    ensure  => directory,
    owner   => root,
    group   => root,
    mode    => 0600,
    recurse => true,
    source  => 'puppet:///modules/ldap/ldif',
    require => Package['ldap-demo'],
    notify  => [
      Exec['ldif_import'],
      Service['ldap-demo']
    ],
  }

  file { '/etc/ldap-demo/ld_import.sh':
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0700',
    content => template('ldap/ld_import.erb'),
    require => Package['ldap-demo'],
  }

  exec { 'ldif_import':
    command     => '/etc/ldap-demo/ld_import.sh',
    refreshonly => 'true',
    require     => [
      Package['openldap-clients'],
      File['/etc/ldap-demo/ld_import.sh'],
      File["$ldif_folder"]
    ],
  }

  service { 'ldap-demo':
    ensure    => running,
    enable    => false,
    subscribe => File['/etc/ldap-demo/conf.d/ldap.conf'],
    notify    => Exec['ldif_import'],
  }

}
