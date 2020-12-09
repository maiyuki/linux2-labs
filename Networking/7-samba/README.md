# Lab 6 - SAMBA

## Description

Samba provides server and client software to allow file sharing between Linux and Windows machines. It allows us to share files and print services using the SMB/CIFS protocol.

## Prerequisites

none

## Objectives

- Set up a SAMBA server on `server01`
- Manual mount file system to `client01`
- Automount file system to `client02`

## Software

Samba, coreutils and policycoreutils-python-utils packages

## Vagrant

Network: `172.22.100.0/24`

Creates three VMs
`server01 172.22.100.10`
`client01 172.22.100.20`
`client02 172.22.100.30`

## TODO

### Setup SAMBA Server

#### Install SAMBA

- Download and cache in binary format metadata for all known repos

- Install `samba` server package

- Start smb server service

- Enable it to automatically start at system boot

- Verify its status

#### Create SAMBA user and group

- We will use our Linux `vagrant` user to access samba. Create SAMBA password for `vagrant` user

- Create `samba` group and add `vagrant` user to the group

- Verify that the user is added to the `samba` group

#### Create SAMBA private share

- Create share `/srv/samba/private/`

- Add file in the directory

- Allow `samba` group to have `read`, `write` and `execute` permission on the shared directory

- Label this directory with `samba_share_t` so that SELinux allows Samba to read and write to it

(*You will learn about SELinux in the security course*)

```bash
chcon -t samba_share_t /srv/samba/private/ -R
```

#### Configure Samba to share a private directory

The main Samba configuration file is located at `/etc/samba/smb.conf`. By default, there are 4 secions: `[global]`, `[homes]`, `[printers]` and `[print$]`

In the `/etc/samba/smb.conf`:

- Remove `[printers]`, `[print$]` and `[home]` because we don't have any of those

- In `[global]`, add value `hosts allow` to `127.0.0.1` and `172.22.100.0/24`

- Add a `[private]` that we can use `username and password` to access, a `path to the private share`, `no guest allowed`, `writable` and valid users are users in `samba group`

- Restart samba service

- Verify that the configuration

#### Configure firewall

- Enable firewalld

- Start firewalld

- Check the status of firewalld

- Allow access to samba service

- Reload for the changes to take effect

### Accessing the Samba private directory

#### Install CIFS on client

- Download and cache in binary format metadata for all known repos

- Install CIFS utils

- Create a mount point for the Samba share

- Mount a the private shared directory

- Verify that you can see the textfile from the server

- Verify that you can add files in the shared directory

- Automount SAMBA share

- Create the credential file `/etc/samba-credential.conf` with password, username and domain

- Give only root user can read access to the file

## Guide / answers

### Setup SAMBA Server

#### Install SAMBA

- Download and cache in binary format metadata for all known repos

```bash
dnf makecache
```

- Install `samba` server package

```bash
dnf install samba
```

- Start smb server service

```bash
systemctl start smb
```

- Enable it to automatically start at system boot

```bash
systemctl enable smb
```

- Verify its status

```bash
systemctl status smb
```

#### Create SAMBA user and group

- We will use our Linux `vagrant` user to access samba. Create SAMBA password for `vagrant` user

```bash
sudo smbpasswd –a vagrant
```

- Create `samba` group and add `vagrant` user to the group

```bash
groupadd samba
gpasswd -a vagrant samba
```

- Verify that the user is added to the `samba` group

```bash
getent group samba
```

#### Create SAMBA private share

- Create share `/srv/samba/private/`

```bash
mkdir -p /srv/samba/private/
```

- Add file in the directory

```bash
touch /srv/samba/private/private_file.txt
```

- Allow `samba` group to have `read`, `write` and `execute` permission on the shared directory

```bash
setfacl -R -m "g:samba:rwx" /srv/samba/private/
```

- Label this directory with `samba_share_t` so that SELinux allows Samba to read and write to it

(*You will learn about SELinux in the security course*)

```bash
chcon -t samba_share_t /srv/samba/private/ -R
```

#### Configure Samba to share a private directory

The main Samba configuration file is located at `/etc/samba/smb.conf`. By default, there are 4 secions: `[global]`, `[homes]`, `[printers]` and `[print$]`

In the `/etc/samba/smb.conf`:

- Remove `[printers]`, `[print$]` and `[home]` because we don't have any of those

- In `[global]`, add value `hosts allow` to `127.0.0.1` and `172.22.100.0/24`

- Add a `[private]` that we can use `username and password` to access, a `path to the private share`, `no guest allowed`, `writable` and valid users are users in `samba group`

```bash
[global]
        workgroup = SAMBA
        security = user

        passdb backend = tdbsam

        printing = cups
        printcap name = cups
        load printers = yes
        cups options = raw

        hosts allow = 127.0.0.1 172.22.100.0/24

[private]
        comment = Access with username and password
        path = /srv/samba/private/
        browseable = yes
        guest ok = no
        writable = yes
        valid users = @samba
```

- Restart samba service

```bash
systemctl restart smb
```

- Verify that the configuration

```bash
testparm
```

#### Configure firewall

- Enable firewalld

```bash
systemctl enable firewalld
```

- Start firewalld

```bash
systemctl start firewalld
```

- Check the status of firewalld

```bash
systemctl status firewalld
```

- Allow access to samba service

```bash
firewall-cmd --permanent --add-service=samba
```

- Reload for the changes to take effect

```bash
firewall-cmd --reload
```

### Accessing the Samba private directory

#### Install CIFS on client

- Download and cache in binary format metadata for all known repos

```bash
dnf makecache
```

- Install CIFS utils

```bash
dnf install cifs-utils
```

- Create a mount point for the Samba share

```bash
mkdir -p /mnt/samba/private/
```

- Mount a the private shared directory

```bash
mount -t cifs -o username=vagrant //172.22.100.10/private /mnt/samba/private/
```

- Verify that you can see the textfile from the server

```bash
ls -l /mnt/samba/private/
```

- Verify that you can add files in the shared directory

```bash
touch /mnt/samba/private/from-client01.txt
```

- Automount SAMBA share

```bash
echo "//172.22.10.10/private   /mnt/samba/private  cifs     x-systemd.automount,_netdev,credentials=/etc/samba-credential.conf,uid=1000,gid=1000,x-gvfs-show   0   0
">>/etc/fstab
```

- Create the credential file `/etc/samba-credential.conf` with password, username and domain

```bash
username=vagrant
password=<fill-in>
domain=SAMBA
```

- Give only root user can read access to the file

```bash
chmod 600 /etc/samba-credential.conf
```

## Extra

- Setup client02 with a user `vagrant2` and mount file system
- Create Samba Public Share Without Authentication

Hint!
- You need to modify `[global]` in `/etc/samba/smb.conf`
- Add a new section `[public]` with values in - path, browseable, writable, guest ok

## Link

[SAMBA with Linux and Windows](https://www.linuxbabe.com/redhat/set-up-samba-server-on-centos-8-rhel-8-for-file-sharing)
