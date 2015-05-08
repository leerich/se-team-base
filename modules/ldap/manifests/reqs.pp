class ldap::reqs {

  firewall { '111 allow connections to apacheds':
    proto   => 'tcp',
    dport   => '10389',
    action  => 'accept',
  }

  package { 'openldap-clients':
    ensure => present,
  }

}
