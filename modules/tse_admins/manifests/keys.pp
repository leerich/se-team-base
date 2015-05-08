define tse_admins::keys (
  $sshkey = $title,
  $username,
) {
  
  # keys come in as 'key_type key_content key_name'
  # or 'key_type key_content'
  $key_array   = split($sshkey, ' ')
  $key_type    = $key_array[0]
  $key_content = $key_array[1]
 
  # we don't always get the last string, keyname, so if we don't have it, make a sha1 hash of the content to use instead
  if $key_array[2] != undef {
    $key_name = $key_array[2]
  }
  else {
    $key_name = sha1($key_array[1])
  }
  
  $key_title = "${username}_${key_type}_${key_name}"

  # this actually creates the resource, and appends it after the user
  # once compiled into the catalog
  ssh_authorized_key { $key_title:
    ensure  => present,
    user    => $username,
    name    => $key_name,
    key     => $key_content,
    type    => $key_type,
    require => User["${username}"],
  }
}
