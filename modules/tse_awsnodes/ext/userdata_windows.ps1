<powershell> 
$webclient = new-object System.Net.WebClient 

$PE_MASTER = 'hostnamemaster.foo.com'
$PE_VERSION = '9.9.9.9.9'

$AWS_INSTANCE_ID = $webclient.DownloadString("http://169.254.169.254/latest/meta-data/instance-id")

# since we were passed @nodename we are prepending it
# to instance-id
$PE_CERTNAME = "nodenametest-$AWS_INSTANCE_ID"

# these are attributes we know already
$PP_INSTANCE_ID = $AWS_INSTANCE_ID

$PP_IMAGE_NAME = 'pp_image_name ami-4dbf9e7d'

# Create the directory

new-item c:\ProgramData\PuppetLabs\puppet\etc\ -itemtype directory -force

$CSR_ATTRIBUTES = @"
extension_requests:
  pp_instance_id: $PP_INSTANCE_ID
  pp_image_name: $PP_IMAGE_NAME
  pp_uuid: 'pp_uuid BD018C91-EEA2-4641-85C1-3EEA09282639'
  pp_preshared_key: 'pp_preshared_key B7A7136A-5850-4315-BAB6-C3DFE4B41487'
  1.3.6.1.4.1.34380.1.1.5: 'pp_cost_center tse'
  1.3.6.1.4.1.34380.1.1.6: 'pp_product testing code'
  1.3.6.1.4.1.34380.1.1.7: 'pp_project'
  1.3.6.1.4.1.34380.1.1.8: 'pp_application'
  1.3.6.1.4.1.34380.1.1.9: 'pp_service'
  1.3.6.1.4.1.34380.1.1.10: 'pp_employee'
  1.3.6.1.4.1.34380.1.1.11: 'pp_created_by'
  1.3.6.1.4.1.34380.1.1.12: 'pp_environment' 
  1.3.6.1.4.1.34380.1.1.13: 'pp_role'
  1.3.6.1.4.1.34380.1.1.14: 'pp_software_version'
  1.3.6.1.4.1.34380.1.1.15: 'pp_department' 
  1.3.6.1.4.1.34380.1.1.16: 'pp_cluster'
  1.3.6.1.4.1.34380.1.1.17: 'pp_provisioner'
"@

out-file -filepath c:\ProgramData\PuppetLabs\puppet\etc\csr_attributes.yaml -encoding UTF8 -inputobject $CSR_ATTRIBUTES -force

$INSTALLER_URL = "https://s3.amazonaws.com/pe-builds/released/$PE_VERSION/puppet-enterprise-$PE_VERSION-x64.msi"

msiexec /qn /i $INSTALLER_URL PUPPET_MASTER_SERVER="$PE_MASTER" PUPPET_AGENT_CERTNAME="$PE_CERTNAME"
</powershell>
