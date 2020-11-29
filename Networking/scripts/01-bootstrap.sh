#
# 01-bootstrap.sh script
#

firewall-cmd --state >/dev/null 2>&1
if [[ $? != 0 ]]; then
    systemctl enable firewalld.service
    systemctl start firewalld.service
fi


firewall-cmd --state >/dev/null 2>&1
if [[ $? = 0 ]]; then
    firewall-cmd --zone=internal --permanent --change-interface=eth1
    firewall-cmd --zone=internal --permanent --remove-service=ssh
    firewall-cmd --zone=internal --permanent --remove-service=dhcpv6-client
    firewall-cmd --zone=internal --permanent --remove-service=mdns
    firewall-cmd --zone=internal --permanent --remove-service=samba-client
    firewall-cmd --zone=internal --permanent --remove-service=cockpit
    firewall-cmd --reload
fi
