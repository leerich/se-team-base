class tse_admins::cbarker 
{
  user { 'cbarker':
    ensure         => present,
    home           => "/home/cbarker",
    managehome     => true,
    comment        => "cbarker's Account created by tse_admins module",
    forcelocal     => true,
    groups         => 'wheel',
    purge_ssh_keys => true,
    shell          => '/bin/bash',
  }

  file_line { "cbarker_puppet_path":
    ensure  => present,
    line    => 'PATH=$PATH:/opt/puppet/bin/',
    path    => "/home/cbarker/.bashrc",
    require => User['cbarker'],
  }

  ssh_authorized_key { 'cbarker@puppetlabs.com':
    ensure  => present,
    user    => 'cbarker',
    name    => 'cbarker@puppetlabs.com',
    key     => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDiuh3j8KLFJIR/39956ZhilKtMTr7ivm9e6K4/pzU2Cqvg4pBeXPGglbJqz6TNnD+IL9PJefFwmNlxpim8ARY+h2zXN25SLhZzoM3/wPqt9Q5+r0ylpdlXGLCilMl7m2OfBPhvNDm5DJSCQ9XwRvt0K66DvZ6A/43jchtt6xFC7N9ZHCLXPFTeaEO19IyjGFtlS0eLpKRn9oVKAzwPOTKyuWD5aveHTlI0UqqZnY/aWvcq6mA8yymmbxOm9AkXaAyMoirdoH+7pHuMWPUw0keQzBfwHsXbeRP+G4I0QyTUJgqioXFU1bn4oDaprU1BP23F+agBedriewtiNewSqJWJ',
    type    => 'ssh-rsa',
    require => User['cbarker'],
  }
}
