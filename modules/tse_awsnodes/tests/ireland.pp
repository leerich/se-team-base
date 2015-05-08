class { 'tse_awsnodes::vpc':
  region => 'eu-west-1',
}
class { 'tse_awsnodes::securitygroups':
  region  => 'eu-west-1',
  require => Class['tse_awsnodes::vpc'],
}
