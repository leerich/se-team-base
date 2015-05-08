Simple LDAP install / configuration module

This is using the internal PuppetLabs trapperkeeper / ezbake apacheds rpm, and is entirely useless for anyone outside of PL.

the ld\_import.erb template just loads anything it finds in $LDIF folder into the apacheds instance. The manifest handles making sure that script is run anytime it has to change the list of users in the $LDIF folder, or it has to restart / refresh the ldap-demo service, since it is using only inmemory storage and needs to be seeded after every restart.

