define tse_admins::user (
  $username = $title,
  $longname,
  $group = 'tseadmin',
  $shell = '/bin/bash',
  $sshkeys,
) {

  # we are specific about this users setup
  user { $username:
    ensure         => present,
    home           => "/home/${username}",
    managehome     => true,
    comment        => "${longname}'s Account created by tse_admins module",
    forcelocal     => true,
    groups         => $group,
    purge_ssh_keys => true,
    shell          => $shell,
  }

  # make sure we have puppet in the path in the bashrc, but don't do anything else
  file_line { "${username}_puppet_path":
    ensure  => present,
    line    => 'PATH=$PATH:/opt/puppet/bin/',
    path    => "/home/${username}/.bashrc",
    require => User[$username],
  }

  # since you can put an array of ssh keys, we are making this possible to easily install N number keys
  tse_admins::keys { $sshkeys:
    username => $username,
  }
}
