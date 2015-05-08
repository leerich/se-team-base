#class to test userdata erb templates
# we are just setting all the variables


$pe_master_hostname = 'hostname: master.foo.com'
$pe_version_string = '9.9.9.9.9'


file { '/Users/cbarker/oscar/pe371/environments/production/modules/tse_awsnodes/ext/userdata_linux_empty.sh':
  ensure => file,
  content => template('tse_awsnodes/linux.erb'),
}

file { '/Users/cbarker/oscar/pe371/environments/production/modules/tse_awsnodes/ext/userdata_windows_empty.ps1':
  ensure => file,
  content => template('tse_awsnodes/windows.erb'),
}

