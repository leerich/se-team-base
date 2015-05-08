# this is a profile to setup our base windows requirements
class tse_windows {

  user { 'tseadmin':
    ensure   => present,
    comment  => 'Created for TSE access to these machines',
    groups   => ['Users','Administrators'],
    password => 'PuppetLabs!123',
  }

  if $::operatingsystemmajrelease == '2012 R2' {
    registry::value { 'DisableNLA':
      key   => 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp',
      value => UserAuthentication,
      type  => 'dword',
      data  => '0',
    }
  }

  windows_firewall::exception { 'RDPAccess':
    ensure       => present,
    direction    => 'in',
    action       => 'Allow',
    enabled      => 'yes',
    protocol     => 'TCP',
    local_port   => '3389',
    display_name => 'Windows RDP',
    description  => "Windows RDP Inbound Access, enabled by Puppet in $module_name",
  }

}
