ec2_instance { 'canary-us-west-2':
  ensure         => stopped,
  image_id       => 'ami-7f79544f',
  instance_type  => 't2.micro',
  region         => 'us-west-2',
  subnet         => 'tse-subnet-avza-1',
  tags           => {
    'department' => 'ops',
    'project'    => 'canaries',
    'created_by' => 'sylvester',
  },
}
#ec2_instance { 'canary-ap-southeast-2':
#  ensure        => present,
#  image_id      => 'ami-4d1e6e77',
#  instance_type => 't2.micro',
#  region        => 'ap-southeast-2',
#  tags          => {
#    'department'    => 'ops',
#    'project'       => 'canaries',
#    'created_by'    => 'sylvester', 
#  },
#}
#ec2_instance { 'canary-eu-west-1':
#  ensure        => present,
#  image_id      => 'ami-ef158898',
#  instance_type => 't2.micro',
#  region        => 'eu-west-1',
#  tags          => {
#    'department'    => 'ops',
#    'project'       => 'canaries',
#    'created_by'    => 'sylvester', 
#  },
#}
