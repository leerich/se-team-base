#class to test userdata erb templates
# we are just setting all the variables


$pe_master_hostname = 'hostnamemaster.foo.com'
$pe_version_string = '9.9.9.9.9'
$nodename = 'nodenametest'
$pp_uuid = 'pp_uuid BD018C91-EEA2-4641-85C1-3EEA09282639'
$pp_instance_id = 'pp_instance_id i-4502f24a'
$pp_image_name = 'pp_image_name ami-4dbf9e7d'
$pp_preshared_key = 'pp_preshared_key B7A7136A-5850-4315-BAB6-C3DFE4B41487'
$pp_cost_center = 'pp_cost_center tse'
$pp_product = 'pp_product testing code'
$pp_project = 'pp_project'
$pp_application = 'pp_application'
$pp_service = 'pp_service'
$pp_employee = 'pp_employee'
$pp_created_by = 'pp_created_by'
$pp_environment = 'pp_environment'
$pp_role = 'pp_role'
$pp_software_version = 'pp_software_version'
$pp_department = 'pp_department'
$pp_cluster = 'pp_cluster'
$pp_provisioner = 'pp_provisioner'


file { '/Users/cbarker/oscar/pe371/environments/production/modules/tse_awsnodes/ext/userdata_linux.sh':
  ensure => file,
  content => template('tse_awsnodes/linux.erb'),
}

file { '/Users/cbarker/oscar/pe371/environments/production/modules/tse_awsnodes/ext/userdata_windows.ps1':
  ensure => file,
  content => template('tse_awsnodes/windows.erb'),
}

