class tse_admins (
  $purge = true,
) {

  $tses = hiera_hash('tse_admins')

  $preserved_users = hiera_array('preserved_users')

  create_resources('tse_admins::user', $tses)

  if $purge {
    resources { 'user':
      purge              => true,
      unless_system_user => true,
    }
  }

  user { $preserved_users:
    ensure => present,
  }

  group { 'tseadmin':
    ensure => present,
  }

}
