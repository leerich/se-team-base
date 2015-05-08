<powershell> $webclient = new-object System.Net.WebClient 
$instanceid = $webclient.DownloadString("http://169.254.169.254/latest/meta-data/instance-id")
msiexec /qn /i https://s3.amazonaws.com/pe-builds/released/9.9.9.9.9/puppet-enterprise-9.9.9.9.9.msi PUPPET_MASTER_SERVER=hostname: master.foo.com PUPPET_AGENT_CERTNAME=-$instanceid
</powershell>
