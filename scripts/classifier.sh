#!/bin/bash

# simple 3.7 NC classifier commands

declare -x PE_CERT=$(/opt/puppet/bin/puppet agent --configprint hostcert)
declare -x PE_KEY=$(/opt/puppet/bin/puppet agent --configprint hostprivkey)
declare -x PE_CA=$(/opt/puppet/bin/puppet agent --configprint localcacert)
declare -x PE_CERTNAME=$(/opt/puppet/bin/puppet agent --configprint certname)

declare -x NC_CURL_OPT="-s --cacert $PE_CA --cert $PE_CERT --key $PE_KEY --insecure"

find_guid()
{
  echo $(curl $NC_CURL_OPT --insecure https://localhost:4433/classifier-api/v1/groups| python -m json.tool |grep -C 2 "$1" | grep "id" | cut -d: -f2 | sed 's/[\", ]//g')
}


read -r -d '' PE_MASTER_POST << MASTER_JSON
{
"classes": {
"ldap": { },
"ntp": { },
"profile::pe_env": { },
"pe_repo": { },
"pe_repo::platform::el_6_x86_64": {},
"pe_repo::platform::el_7_x86_64": {},
"pe_repo::platform::ubuntu_1204_amd64": {},
"pe_repo::platform::ubuntu_1404_amd64": {},
"puppet_enterprise::profile::master": { },
"puppet_enterprise::profile::master::mcollective": {},
"puppet_enterprise::profile::mcollective::peadmin": {},
"role::master": {}
},
"environment": "production",
"environment_trumps": false,
"id": "$(find_guid 'PE Master')",
"name": "PE Master",
"parent": "$(find_guid 'PE Infrastructure')",
"rule": [
"or",
[
"=",
"name",
"$PE_CERTNAME"
]
],
"variables": {}
}
MASTER_JSON

read -r -d '' PE_LINUX_GROUP << LINUX_JSON
{
    "classes": {
      "profile::pe_env": {},
      "profile::repos": {
        "offline": "false"
      },
      "ntp": {}
    },
    "environment": "production",
    "environment_trumps": false,
    "name": "Linux Servers",
    "parent": "00000000-0000-4000-8000-000000000000",
    "rule": [
           "and",
        [
            "not",
            [
                "=",
                [
                    "fact",
                    "clientcert"
                ],
                "$PE_CERTNAME"
            ]
        ],
        [
            "=",
            [
                "fact",
                "kernel"
            ],
            "Linux"
        ] 
    ],
    "variables": {}
}
LINUX_JSON

read -r -d '' PE_WINDOWS_GROUP << WINDOWS_JSON
{
    "classes": {
    "chocolatey": {}
    },
    "environment": "production",
    "environment_trumps": false,
    "name": "Windows Servers",
    "parent": "00000000-0000-4000-8000-000000000000",
    "rule": [
        "and",
        [
            "=",
            [
                "fact",
                "kernel"
            ],
            "windows"
        ]
    ],
    "variables": {}
}
WINDOWS_JSON

read -r -d '' PE_MCO_GROUP << MCO_JSON
{
    "classes": {
        "puppet_enterprise::profile::mcollective::agent": {}
    },
    "environment": "production",
    "environment_trumps": false,
    "id": "$(find_guid 'PE MCollective')",
    "name": "PE MCollective",
    "parent": "$(find_guid 'PE Infrastructure')",
    "rule": [
        "and",
        [
            "=",
            [
                "fact",
                "is_admin"
            ],
            "true"
        ],
        [
            "~",
            [
                "fact",
                "pe_version"
            ],
            ".+"
        ]
    ],
    "variables": {}
}
MCO_JSON


curl -X POST -H 'Content-Type: application/json' -d "$PE_MASTER_POST" $NC_CURL_OPT --insecure https://localhost:4433/classifier-api/v1/groups/$(find_guid 'PE Master')

# is admin fact is apparently broken right now on windows / inconsistent based on mco vs service run, etc
#curl -X POST -H 'Content-Type: application/json' -d "$PE_MCO_GROUP" $NC_CURL_OPT --insecure https://localhost:4433/classifier-api/v1/groups/$(find_guid 'PE MCollective')

curl -X POST -H 'Content-Type: application/json' -d "$PE_LINUX_GROUP" $NC_CURL_OPT --insecure https://localhost:4433/classifier-api/v1/groups
curl -X POST -H 'Content-Type: application/json' -d "$PE_WINDOWS_GROUP" $NC_CURL_OPT --insecure https://localhost:4433/classifier-api/v1/groups

