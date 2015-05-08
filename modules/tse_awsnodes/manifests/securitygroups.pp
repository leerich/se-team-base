define tse_awsnodes::securitygroups (
  $region = $title,
) {
  $tse_tags = {
      'department' => 'TSE',
      'project'    => 'Infrastructure',
      'created_by' => 'cbarker',
    }

  ec2_securitygroup { 'tse-master':
    ensure      => present,
    region      => $region,
    vpc         => 'tse-vpc',
    description => 'Security group for use by the Master, and associated ports',
    ingress     => [
      {
        protocol => 'tcp',
        port     => '80',
        cidr     => '0.0.0.0/0',
      },
      {
        protocol => 'tcp',
        port     => '22',
        cidr     => '0.0.0.0/0',
      },
      {
        protocol => 'tcp',
        port     => '443',
        cidr     => '0.0.0.0/0',
      },
      {
        protocol => 'tcp',
        port     => '3000',
        cidr     => '0.0.0.0/0',
      },
      {
        cidr => '10.98.0.0/16', 
        port => '-1', 
        protocol => 'icmp'
      },
    ],
    tags => $tse_tags,
  }

  ec2_securitygroup { 'tse-agents':
    ensure      => present,
    region      => $region,
    vpc         => 'tse-vpc',
    description => 'Security group for use by the agents - allows their port access to master also',
    ingress     => [
      {
        protocol => 'tcp',
        port     => '80',
        cidr     => '0.0.0.0/0',
      },
      {
        protocol => 'tcp',
        port     => '22',
        cidr     => '0.0.0.0/0',
      },
      {
        protocol => 'tcp',
        port     => '443',
        cidr     => '0.0.0.0/0',
      },
      {
        protocol => 'tcp',
        port     => '3389',
        cidr     => '0.0.0.0/0',
      },
      {
        protocol => 'tcp',
        port     => '8080',
        cidr     => '0.0.0.0/0',
      },
      {
        protocol => 'tcp',
        port     => '8000',
        cidr     => '0.0.0.0/0',
      },
      {
        cidr => '10.98.0.0/16', 
        port => '-1', 
        protocol => 'icmp'
      },
    ],
    tags => $tse_tags,
  }


  ec2_securitygroup { 'tse-crossconnect':
    ensure      => present,
    region      => $region,
    vpc         => 'tse-vpc',
    description => 'Security Group that allows masters to talk to agents and vice versa - prevents race condition',
    ingress     => [
      {
        security_group => 'tse-master',
      },
      {
        security_group => 'tse-agents',
      },
    ],
    tags    => $tse_tags,
    require => Ec2_securitygroup['tse-master','tse-agents'],
  }
}
