class { 'tse_awsnodes::vpc':
  region => 'us-west-2',
}
class { 'tse_awsnodes::securitygroups':
  region  => 'us-west-2',
  require => Class['tse_awsnodes::vpc'],
}
