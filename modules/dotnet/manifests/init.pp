class dotnet {

  require profile::staging

  if $kernelmajversion == '6.1' {
    reboot { 'before dotnet install':
      when => pending,
    }

    staging::file { 'dotNetFx40_Full_x86_x64.exe':
      source => "http://${::servername}/dotnetcms/dotNetFx40_Full_x86_x64.exe",
      before => Package['Microsoft .NET Framework 4 Extended'],
    }

    file { 'dotNetFx40_Full_x86_x64.exe':
      path    => 'C:\staging\dotnet\dotNetFx40_Full_x86_x64.exe',
      mode    => 0755,
      owner   => 'vagrant',
      require => Staging::File['dotNetFx40_Full_x86_x64.exe'],
      before  => Package['Microsoft .NET Framework 4 Extended'],
    }

    package { 'Microsoft .NET Framework 4 Extended':
      ensure          => installed,
      source          => 'C:\staging\dotnet\dotNetFx40_Full_x86_x64.exe',
      install_options => ['/q', '/norestart'],
      require => File['dotNetFx40_Full_x86_x64.exe'],
    }

    reboot { 'successful dotnet install':
      subscribe => Package['Microsoft .NET Framework 4 Extended'],
    }
  }

}
