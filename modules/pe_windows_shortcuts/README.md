pe_windows_shortcuts
====================

Puppet Enterprise desktop shortcuts for Windows 2k8/2k12


usage
====================

On Windows Server 2008 machines:

In site.pp

if $::osfamily == 'windows' {
  class { "pe_windows_shortcuts":
    user => 'vagrant',
  }
}

On Windows Server 2012 machines:

In site.pp

if $::osfamily == 'windows' {
  class { "pe_windows_shortcuts":
    user => 'Administrator',
  }
}
