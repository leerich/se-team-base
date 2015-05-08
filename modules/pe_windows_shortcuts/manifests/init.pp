class pe_windows_shortcuts ($user){

  $user_desktop = "C:\Users\\${user}\Desktop"
  $pe_shortcuts = 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Puppet Enterprise'

  file { "$user_desktop\Run Facter.lnk":
    ensure => present,
    source => "$pe_shortcuts\Run Facter.lnk",
  }

  file { "$user_desktop\Start Command Prompt With Puppet.lnk":
    ensure => present,
    source => "$pe_shortcuts\Start Command Prompt With Puppet.lnk",
  }

  file { "$user_desktop\Run Puppet Agent.lnk":
    ensure => present,
    source => "$pe_shortcuts\Run Puppet Agent.lnk",
  }

}
