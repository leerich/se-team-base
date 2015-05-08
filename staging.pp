class splunk_files (
  $srv_root = '/var/seteam-files',
) {

  
  $dir_root   = "${srv_root}/demo_offline_splunk"
  $version    = '6.0'
  $build      = '182037'
  $src_root   = "http://download.splunk.com/releases/${version}"

  $windows    = "${version}-${build}-x64-release.msi"
  $rpm_x86_64 = "${version}-${build}-linux-2.6-x86_64.rpm"
  $rpm_x86    = "${version}-${build}.i386.rpm"
  $deb_x86_64 = "${version}-${build}-linux-2.6-amd64.deb"
  $deb_x86    = "${version}-${build}-linux-2.6-intel.deb"
  $solaris_64 = "${version}-${build}-solaris-10-intel.pkg"

  Staging::File {
    require => File[$dir_root],
  }

  $directories = [
    $dir_root,
    "${dir_root}/splunk",
    "${dir_root}/splunk/linux",
    "${dir_root}/splunk/solaris",
    "${dir_root}/splunk/windows",
    "${dir_root}/universalforwarder",
    "${dir_root}/universalforwarder/linux",
    "${dir_root}/universalforwarder/solaris",
    "${dir_root}/universalforwarder/windows",
  ]

  file { $directories:
    ensure => directory,
    mode   => '0755',
  }

  staging::file { "splunk-${windows}":
    source => "${src_root}/splunk/windows/splunk-${windows}",
    target => "${dir_root}/splunk/windows/splunk-${windows}",
  }
  staging::file { "splunkforwarder-${windows}":
    source => "${src_root}/universalforwarder/windows/splunkforwarder-${windows}",
    target => "${dir_root}/universalforwarder/windows/splunkforwarder-${windows}",
  }

  staging::file { "splunk-${rpm_x86}":
    source => "${src_root}/splunk/linux/splunk-${rpm_x86}",
    target => "${dir_root}/splunk/linux/splunk-${rpm_x86}",
  }
  staging::file { "splunkforwarder-${rpm_x86}":
    source => "${src_root}/universalforwarder/linux/splunkforwarder-${rpm_x86}",
    target => "${dir_root}/universalforwarder/linux/splunkforwarder-${rpm_x86}",
  }

  staging::file { "splunk-${rpm_x86_64}":
    source => "${src_root}/splunk/linux/splunk-${rpm_x86_64}",
    target => "${dir_root}/splunk/linux/splunk-${rpm_x86_64}",
  }
  staging::file { "splunkforwarder-${rpm_x86_64}":
    source => "${src_root}/universalforwarder/linux/splunkforwarder-${rpm_x86_64}",
    target => "${dir_root}/universalforwarder/linux/splunkforwarder-${rpm_x86_64}",
  }

  staging::file { "splunk-${deb_x86}":
    source => "${src_root}/splunk/linux/splunk-${deb_x86}",
    target => "${dir_root}/splunk/linux/splunk-${deb_x86}",
  }
  staging::file { "splunkforwarder-${deb_x86}":
    source => "${src_root}/universalforwarder/linux/splunkforwarder-${deb_x86}",
    target => "${dir_root}/universalforwarder/linux/splunkforwarder-${deb_x86}",
  }

  staging::file { "splunk-${deb_x86_64}":
    source => "${src_root}/splunk/linux/splunk-${deb_x86_64}",
    target => "${dir_root}/splunk/linux/splunk-${deb_x86_64}",
  }
  staging::file { "splunkforwarder-${deb_x86_64}":
    source => "${src_root}/universalforwarder/linux/splunkforwarder-${deb_x86_64}",
    target => "${dir_root}/universalforwarder/linux/splunkforwarder-${deb_x86_64}",
  }

  staging::file { "splunk-${solaris_64}.Z":
    source => "${src_root}/splunk/solaris/splunk-${solaris_64}.Z",
    target => "${dir_root}/splunk/solaris/splunk-${solaris_64}.Z",
  }
  exec { "extract splunk-${solaris_64}.Z":
    path     => '/usr/bin:/bin',
    cwd      => "${dir_root}/splunk/solaris",
    provider => shell,
    command  => "gzip -dc splunk-${solaris_64}.Z > splunk-${solaris_64}",
    creates  => "${dir_root}/splunk/solaris/splunk-${solaris_64}",
    require  => Staging::File["splunk-${solaris_64}.Z"],
  }

  staging::file { "splunkforwarder-${solaris_64}.Z":
    source => "${src_root}/universalforwarder/solaris/splunkforwarder-${solaris_64}.Z",
    target => "${dir_root}/universalforwarder/solaris/splunkforwarder-${solaris_64}.Z",
  }
  exec { "extract splunkforwarder-${solaris_64}.Z":
    path     => '/usr/bin:/bin',
    cwd      => "${dir_root}/universalforwarder/solaris",
    provider => shell,
    command  => "gzip -dc splunkforwarder-${solaris_64}.Z > splunkforwarder-${solaris_64}",
    creates  => "${dir_root}/universalforwarder/solaris/splunkforwarder-${solaris_64}",
    require  => Staging::File["splunkforwarder-${solaris_64}.Z"],
  }

}


class dotnetcms_files (
  $srv_root = '/var/seteam-files',
) {
  
  $directories = [
    "${srv_root}/dotnetcms",
    "${srv_root}/7zip",
  ]

  Staging::File {
    require => File[$directories],
  }

  file { $directories:
    ensure => directory,
    mode   => '0755',
  }

  # dotnetcms
  
  staging::file { 'dotNetFx40_Full_x86_x64.exe':
    source => 'https://s3.amazonaws.com/saleseng/files/dotnetcms/dotNetFx40_Full_x86_x64.exe',
    target => "${srv_root}/dotnetcms/dotNetFx40_Full_x86_x64.exe",
  }
  staging::file { 'CMS4.06.zip':
    source => 'https://s3.amazonaws.com/saleseng/files/dotnetcms/CMS4.06.zip',
    target => "${srv_root}/dotnetcms/CMS4.06.zip",
  }

  # 7zip

  staging::file { '7z920-x64.msi':
    source => 'https://s3.amazonaws.com/saleseng/files/7zip/7z920-x64.msi',
    target => "${srv_root}/7zip/7z920-x64.msi",
  }

}

class tomcat_files (
  $srv_root = '/var/seteam-files',
) {
  
  $directories = [
    "${srv_root}/tomcat",
    "${srv_root}/war",
    "${srv_root}/war/1.400",
    "${srv_root}/war/1.449",
    "${srv_root}/war/1.525",
    "${srv_root}/war/latest",
  ]

  Staging::File {
    require => File[$directories],
  }

  file { $directories:
    ensure => directory,
    mode   => '0755',
  }

  staging::file { 'apache-tomcat-6.0.35.tar.gz':
    source => 'https://s3.amazonaws.com/saleseng/files/tomcat/apache-tomcat-6.0.35.tar.gz',
    target => "${srv_root}/tomcat/apache-tomcat-6.0.35.tar.gz",
  }
  staging::file { 'apache-tomcat-7.0.25.tar.gz':
    source => 'https://s3.amazonaws.com/saleseng/files/tomcat/apache-tomcat-7.0.25.tar.gz',
    target => "${srv_root}/tomcat/apache-tomcat-7.0.25.tar.gz",
  }
  staging::file { 'jenkins-1.400.war':
    source => 'https://s3.amazonaws.com/saleseng/files/tomcat/jenkins-1.400.war',
    target => "${srv_root}/war/1.400/jenkins.war",
  }
  staging::file { 'jenkins-1.449.war':
    source => 'https://s3.amazonaws.com/saleseng/files/tomcat/jenkins-1.449.war',
    target => "${srv_root}/war/1.449/jenkins.war",
  }
  staging::file { 'jenkins-1.525.war':
    source => 'http://mirrors.jenkins-ci.org/war/1.525/jenkins.war',
    target => "${srv_root}/war/1.525/jenkins.war",
  }
  staging::file { 'jenkins-latest.war':
    source => 'http://mirrors.jenkins-ci.org/war/latest/jenkins.war',
    target => "${srv_root}/war/latest/jenkins.war",
  }
  staging::file { 'sample-1.0.war':
    source => 'https://s3.amazonaws.com/saleseng/files/tomcat/sample-1.0.war',
    target => "${srv_root}/tomcat/plsample-1.0.war",
  }
  staging::file { 'sample-1.2.war':
    source => 'https://s3.amazonaws.com/saleseng/files/tomcat/sample-1.2.war',
    target => "${srv_root}/tomcat/plsample-1.2.war",
  }
}

$sefiles = $virtual ? {
  'virtualbox' => '/var/seteam-files',
  default      => '/opt/seteam-files',
}
file { $sefiles:
  ensure  => directory,
}
class { 'splunk_files': srv_root    => $sefiles, }
class { 'dotnetcms_files': srv_root => $sefiles, }
class { 'tomcat_files': srv_root    => $sefiles, }
