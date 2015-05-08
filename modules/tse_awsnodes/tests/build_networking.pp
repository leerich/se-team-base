tse_awsnodes::vpc { 'us-west-2': }
tse_awsnodes::securitygroups { 'us-west-2': 
  require => Tse_awsnodes::Vpc ['us-west-2'],
}
