#
# 02-install-nginx-service.sh
#

dnf makecache
dnf install -y epel-release

rpm -q nginx 2>&1 >/dev/null
if [[ $? != 0 ]]; then
    dnf install -y nginx

    systemctl enable nginx.service
    systemctl start nginx.service
fi

rpm -q nginx 2>&1 >/dev/null
if [[ $? == 0 ]]; then
    cp /home/vagrant/app/nginx.conf /etc/nginx/nginx.conf
    rm /home/vagrant/app/nginx.conf
    restorecon -Rv /etc/nginx/nginx.conf

    echo "c2VkIC1pIC1lICczNXMvODAvODEvJyAtZSAnMzZzLzgwLzgxLycgL2V0Yy9uZ2lueC9uZ2lueC5jb25mCg==" | base64 -d | bash
    systemctl restart nginx.service
fi

rpm -q python3 2>&1 >/dev/null
if [[ $? == 1 ]]; then
    dnf install -y gcc python3 python3-wheel python3-devel policycoreutils-python-utils
    python3 -m pip install flask uwsgi pymysql

    install --mode 640 --owner root --group root \
        /home/vagrant/app/flaskapp.service \
        /etc/systemd/system/

    restorecon -Rv /etc/systemd/system/flaskapp.service
    systemctl daemon-reload

    semanage fcontext -a -t httpd_sys_content_t "/opt/app(/.*)?"
    checkmodule -M -m -o /home/vagrant/nginx.mod /home/vagrant/app/selinux-nginx.te
    semodule_package -o /home/vagrant/nginx.pp -m /home/vagrant/nginx.mod
    semodule -i /home/vagrant/nginx.pp

    rm -f /home/vagrant/app/flaskapp.service /home/vagrant/app/nginx.te
    mv /home/vagrant/app /opt/app
    restorecon -Rv /opt/app

    systemctl enable flaskapp.service
    systemctl start flaskapp.service
fi
