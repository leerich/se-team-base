# SE Team Puppet Environments #

## Environments ##

Each branch of this repository is a self-contained Puppet environment with its
own puppet.conf file, it's own hiera.yaml, it's own data directory, and it's
own Puppetfile listing the modules to retrieve in order to set up for the
target scenario.

By convention, most demonstrations are named in such a way as to denote their
purpose and under what rough conditions they will work.

    demo_(online|offline)_[a-z]+

### Online ###

Online demonstrations will require an internet connection in order to work.

### Offline ###

Offline demonstrations should work in the absence of an internet connection, or
any non-local network connectivity at all.

## Creating Environments ##

To create a new environment, check out a new branch based on production. Then
edit the Puppetfile to reference all of the modules you will need, being
specific to version or commit. The primary purpose of the Puppetfile is to
provide a means to strictly re-create a known-state at a later point in time so
versions are very important.

Create or edit the README.md file to include a description of how the demo
works and what it's for.

Optionally, you may edit the hiera.yaml file and create any data you need.

### For Online Demos ###

After you've created the new branch and edited the Puppetfile/README/hiera,
you're done!

#### General Procedure ####

1. Create a new branch based off of production following the naming convention
   `demo_online_*`
2. Modify the README.md file with description and instruction for the demo
3. Populate the Puppetfile with the modules to be used in the demo
4. Edit hiera.yaml and create any data needed for the demo
5. Push the new branch up to the origin repository

### For Offline Demos ###

Offline demos often require content available, such as local installers, RPMs,
large disk files, or other artifacts. We use the staging pattern and Puppet to
ensure that the content we need is downloaded to and made available on the
Puppet Master system when it is provisioned, so that it will be available
offline later.

The Puppet master system runs an Apache server on port 80 to serve these files.

When the Puppet master system is provisioned, it will deploy every environment
(branch) from this repository into /etc/puppetlabs/puppet/environments. It will
then perform a Puppet run where it will import and therefore apply all Puppet
manifests matching the glob
`/etc/puppetlabs/puppet/environments/*/manifests/staging.pp`.

To specify content for an environment that should be staged for later offline
use, create a file in the environment called `manifests/staging.pp` and use
staging::file or staging::deploy resources to ensure content is available under
`/var/seteam-files`. An example staging.pp file is given below. Note that these
files should be treated as if they are stand-alone content that will be used
directly a la `puppet apply`.

    class demo_offline_example (
      $srv_root = '/var/seteam-files',
    ) {

      file { "${srv_root}/demo_offline_example":
        ensure => directory,
        mode   => '0755',
      }

      staging::file { 'demo_offline_example/example_a.tar.gz':
        source => "http://example.com/example_a.tar.gz",
        target => "${srv_root}/demo_offline_example/example_a.tar.gz",
      }

      staging::file { 'demo_offline_example/example_b.tar.gz':
        source => "http://example.com/example_b.tar.gz",
        target => "${srv_root}/demo_offline_example/example_b.tar.gz",
      }

    }

    include demo_offline_example

#### General Procedure ####

1. Create a new branch based off of production following the naming convention
   `demo_offline_*`
2. Modify the README.md file with description and instruction for the demo
3. Populate the Puppetfile with the modules to be used in the demo
4. Create a staging.pp file calling out what content needs to be
   created/available on the master
5. Edit hiera.yaml and create any data needed for the demo
6. Push the new branch up to the origin repository
