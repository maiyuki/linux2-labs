# Lab 6 - SAMBA

## Description

Samba provides server and client software to allow file sharing between Linux and Windows machines. It allow us to share files and print services using the SMB/CIFS protocol.

## Prerequisites

none

## Objectives

- Setup a SAMBA server on `server01`
- Manual mount file system to `client01`
- Auto mount file system to `client01`

## Software

Samba, coreutils and policycoreutils-python-utils packages

## Vagrant

Creates two VM.
`server01 172.22.100.10`
`client01 172.22.100.20`

## TODO

### Always start with update in a new machine

```bash
dnf makecache
dnf repolist --enabled
```

---

### `samba-server/`

- Install Samba:

```bash

```

---

### `samba-client`

- Install Samba

```bash
dnf install samba samba-client
```

- Enable smb and nmb daemon at boot

```bash
systemctl enable --now {smb,nmb}
```

- Open up the ports, so that the samba-shared resources can be accessible from other machines

- Gather information (ports) about the samba service

```bash
firewall-cmd --info-service samba
```


- Permanently add the service to the default zone

```bash
firewall-cmd --permanent --add-service=samba
```

- Reload the firewall configuration

```bash
firewall-cmd --reload
```

- Verify that Samba is a part of our zone

```bash
firewall-cmd --list-services
```

- Configure a share accessible only by registered users
- **TODO**

## Extra

- Setup client02 and mount file system
- Create a file that only you can edit. Verify that client01 cannot edit client02's files

## Link

[DHCP Servers](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/networking_guide/ch-dhcp_servers)
