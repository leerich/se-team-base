Facter.add('datacenter') do
  setcode do
    domain = Facter.value('domain')
    case domain
    when 'inf.puppetlabs.demo' 
      'infrastructure'
    when 'syd.puppetlabs.demo'
      'sydney'
    when 'pdx.puppetlabs.demo'
      'portland'
    else
      'unknown'
    end
  end
end
