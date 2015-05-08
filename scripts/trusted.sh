curl -X POST -H 'Content-Type: application/json' \
-d \
'{
    "name": "TrustedFact",
    "environment": "production",
    "parent": "00000000-0000-4000-8000-000000000000",
    "rule": [
        "=",
        [
            "trusted",
            "certname"
        ],
        "master.inf.puppetlabs.demo"
    ],
    "classes": {
        "ntp": {}
    },
    "variables": {}
}' \
--cacert `/opt/puppet/bin/puppet agent --configprint localcacert` --cert `/opt/puppet/bin/puppet agent --configprint hostcert` --key `/opt/puppet/bin/puppet agent --configprint hostprivkey` --insecure https://localhost:4433/classifier-api/v1/groups | python -m json.tool
