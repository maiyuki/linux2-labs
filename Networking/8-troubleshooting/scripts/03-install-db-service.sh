#
# 03-install-db-service.sh
#

rpm -q mariadb-server 2>&1 >/dev/null
if [[ $? != 0 ]]; then
    dnf makecache
    dnf install -y mariadb-server

    systemctl enable mariadb.service
    systemctl start mariadb.service
fi

rpm -q mariadb-server 2>&1 >/dev/null
if [[ $? == 0 ]]; then
    echo "c2VkIC1pIC1lICdzL14jYmluZC1hZGRyZXNzPS9iaW5kLWFkZHJlc3M9L2cnIC9ldGMvbXkuY25mLmQvbWFyaWFkYi1zZXJ2ZXIuY25mCg==" | base64 -d | bash
    systemctl restart mariadb.service

    echo "GRANT ALL PRIVILEGES ON *.* TO 'user'@'172.22.100.%' IDENTIFIED BY 'password' WITH GRANT OPTION; FLUSH PRIVILEGES;" | mysql -u root
    echo "GRANT ALL PRIVILEGES ON *.* TO 'vagrant'@'172.22.100.%' IDENTIFIED BY 'vagrant' WITH GRANT OPTION; FLUSH PRIVILEGES;" | mysql -u root

    firewall-cmd --zone=public --permanent --add-service=mysql
    firewall-cmd --zone=internal --permanent --add-service=mysql
    firewall-cmd --reload
fi
