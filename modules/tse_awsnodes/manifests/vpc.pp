define tse_awsnodes::vpc (
  $region = $title,
) {

  $tse_tags = {
    'department' => 'TSE',
    'project'    => 'Infrastructure',
    'created_by' => 'cbarker',
  }

  ec2_vpc { 'tse-vpc':
    ensure     => present,
    region     => $region,
    cidr_block => '10.98.0.0/16',
    tags       => $tse_tags,
  }

  ec2_vpc_subnet { 'tse-subnet-avza-1':
    ensure                  => present,
    region                  => $region,
    vpc                     => 'tse-vpc',
    cidr_block              => '10.98.10.0/24',
    availability_zone       => "${region}a",
    route_table             => 'tse-routes',
    map_public_ip_on_launch => true,
    require                 => Ec2_vpc['tse-vpc'],
    tags                    => $tse_tags,
  }
  ec2_vpc_subnet { 'tse-subnet-avza-2':
    ensure                  => present,
    region                  => $region,
    vpc                     => 'tse-vpc',
    cidr_block              => '10.98.20.0/24',
    availability_zone       => "${region}a",
    route_table             => 'tse-routes',
    map_public_ip_on_launch => true,
    require                 => Ec2_vpc['tse-vpc'],
    tags                    => $tse_tags,
  }
  ec2_vpc_subnet { 'tse-subnet-avza-3':
    ensure                  => present,
    region                  => $region,
    vpc                     => 'tse-vpc',
    cidr_block              => '10.98.30.0/24',
    availability_zone       => "${region}a",
    route_table             => 'tse-routes',
    map_public_ip_on_launch => true,
    require                 => Ec2_vpc['tse-vpc'],
    tags                    => $tse_tags,
  }
  ec2_vpc_subnet { 'tse-subnet-avzb-1':
    ensure                  => present,
    region                  => $region,
    vpc                     => 'tse-vpc',
    cidr_block              => '10.98.110.0/24',
    availability_zone       => "${region}b",
    route_table             => 'tse-routes',
    map_public_ip_on_launch => true,
    require                 => Ec2_vpc['tse-vpc'],
    tags                    => $tse_tags,
  }
  
  ec2_vpc_internet_gateway { 'tse-igw':
    ensure  => present,
    region  => $region,
    vpc     => 'tse-vpc',
    require => Ec2_vpc['tse-vpc'],
    tags    => $tse_tags,
  }

  ec2_vpc_routetable { 'tse-routes':
    ensure => present,
    region => $region,
    vpc    => 'tse-vpc',
    routes => [
      {
        destination_cidr_block => '10.98.0.0/16',
        gateway                => 'local',
      },
      {
        destination_cidr_block => '0.0.0.0/0',
        gateway                => 'tse-igw',
      },
    ],
    require  => [
      Ec2_vpc['tse-vpc'],
      Ec2_vpc_internet_gateway['tse-igw'],
    ],
    tags => $tse_tags,
  }

}
