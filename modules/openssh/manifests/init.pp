class openssh {

  case $::osfamily {
    'RedHat': { include openssh::redhat }
    'Debian': { include openssh::debian }
    default:  { notify { "Class[openssh] does not support $::osfamily": } }
  }

}
