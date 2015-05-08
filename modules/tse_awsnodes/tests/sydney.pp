class { 'tse_awsnodes::vpc':
  region => 'ap-southeast-2',
}
class { 'tse_awsnodes::securitygroups':
  region  => 'ap-southeast-2',
  require => Class['tse_awsnodes::vpc'],
}
