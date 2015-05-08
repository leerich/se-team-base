tse\_admins module

This is an example profile module using hiera to populate a list of users that should be installed on a system.

files/example\_hiera.yaml contains the format for a user account, it is passed using create\_resources to the tse\_admins::user defined type. When called with purge => true, the module will purge all user accounts, if you have specific user accounts you want to use, add them to hiera. For an example hierarchy and data, files/hiera.yaml and files/hieradata is already populated with both user accounts to ensure present and full accounts to be created (enjoy our public keys, feel free to give me access to your servers if you want).

For more information on the hiera\_hash and hiera\_array functions, see: https://docs.puppetlabs.com/hiera/1/puppet.html#hiera-lookup-functions

To test this on a system via puppet apply, something like this would work:

puppet apply tests/init.pp --modulepath=/vagrant/modules/ --hiera\_config=/vagrant/modules/tse\_admins/files/hiera.yaml --noop
