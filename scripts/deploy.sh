#!/bin/bash

# this is the universal configuration script
# untar the environments code, and this now 
# moves everything it needs into place
# and configures the master

working_dir=$(basename $(cd $(dirname $0) && pwd))
containing_dir=$(cd $(dirname $0)/.. && pwd)
puppetenv=$(/opt/puppet/bin/puppet config print environmentpath)
scriptpath="${puppetenv}/production/scripts"
basename="${containing_dir}/${working_dir}"

# see if we are already in our working directory
if [ $basename != "${puppetenv}/production/scripts" ]; then
  /bin/cp -Rfu $basename/../* $puppetenv/production/
fi

/opt/puppet/bin/puppet config set disable_warnings deprecations --section main

/opt/puppet/bin/puppet config set environment_timeout 0 --section main

/opt/puppet/bin/puppet config set hiera_config $puppetenv/production/hiera.yaml --section main

/opt/puppet/bin/puppet resource service pe-puppetserver ensure=stopped
/opt/puppet/bin/puppet resource service pe-puppetserver ensure=running
# disable live management
sed -i 's/disable_live_management: false/disable_live_management: true/g' /etc/puppetlabs/puppet-dashboard/settings.yml
/opt/puppet/bin/puppet resource service pe-httpd ensure=stopped
/opt/puppet/bin/puppet resource service pe-httpd ensure=running

# apply our master role
/opt/puppet/bin/puppet apply --exec 'include role::master'

/opt/puppet/bin/puppet apply /etc/puppetlabs/puppet/environments/production/staging.pp

/opt/puppet/bin/puppet apply /etc/puppetlabs/puppet/environments/production/offline_repo.pp

/bin/bash $scriptpath/refresh_classes.sh
/bin/bash $scriptpath/classifier.sh

/bin/bash $scriptpath/connect_ds.sh

/opt/puppet/bin/puppet agent --onetime --no-daemonize --color=false --verbose

if [ ! -z "$(/opt/puppet/bin/facter -p ec2_iam_info_0)" ]; then
  echo "on a properly setup AWS node, deploy the herd"
  /opt/puppet/bin/gem install aws-sdk-core retries
  /opt/puppet/bin/puppet apply --exec 'include tse_awsnodes::deploy'
fi
