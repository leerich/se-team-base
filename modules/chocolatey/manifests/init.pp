class chocolatey (
  $url           = 'https://chocolatey.org/api/v2/package/chocolatey/0.9.8.33',
  $unzip         = '7za',
  $download_path = 'c:\\Windows\\Temp\\',) {
  validate_re($unzip, '^(7za|windows)$')

  file { 'chocolatey script':
    path   => "${download_path}\\InstallChocolatey.ps1",
    source => 'puppet:///modules/chocolatey/InstallChocolatey.ps1',
  }

  exec { 'install chocolatey':
    command   => "& '${download_path}\\InstallChocolatey.ps1' $url $unzip",
    provider  => powershell,
    subscribe => File['chocolatey script'],
    creates   => 'c:\\ProgramData\\chocolatey\\',
    tries     => '2',
  }

  reboot { 'chocolatey reboot':
    subscribe => Exec['install chocolatey'],
    apply     => finished,
  }


}
