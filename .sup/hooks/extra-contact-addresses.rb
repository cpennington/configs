CONTACTS.each do |contact|
    log contact
end
CONTACTS
#ldapsearch -h "wgldap.wgenhq.net" -p "3268" -D "WGENHQ\cpennington" -x -b 'OU=Users,OU=Corporate,DC=wgenhq,DC=net' -W '(objectclass=user)' 'mail' 'displayName' | less
#ldapsearch -h "wgldap.wgenhq.net" -p "3268" -D "WGENHQ\cpennington" -x -b 'OU=Distribution Groups,OU=Corporate,DC=wgenhq,DC=net' -W '(objectclass=group)' 'mail' 'displayName' | less

