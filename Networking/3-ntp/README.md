# Lab 2 - NTP

## Description

A networking protocol for clock synchronization between computer systems. Chrony is a default NTP client as well as an NTP server on RHEL 8 / CentOS 8.

## Prerequisites

none

## Objectives

- Setup an NTP server on `server01`
- Configure `client01` to sync its time to `server01`
- Configure NTP with `timedatectl`on `client01` **TODO**

## Software

chrony (chrony)

## Vagrant

Creates two VMs
`server01 172.22.100.10`
`client01 172.22.100.20`

## Always start with update in a new machine

```bash
dnf makecache
dnf repolist --enabled
```

## TODO

### Install `server01`

- Install Chrony NTP:

```bash
dnf install chrony
```

- Enable chrony to start after boot:

```bash
systemctl enable chronyd
```

- Set Chrony to act as an NTP server for the local network. Edit file `/etc/chrony.conf`

```bash
# Allow NTP client access from local network.
allow 172.22.100.0/24
```

- Restart Chrony NTP daemon to apply the changes

```bash
systemctl restart chronyd
```

- Open firewall port to allow for incoming NTP requests

```bash
firewall-cmd --permanent --add-service=ntp
firewall-cmd --reload
```

- Check chrony sources

```bash
chronyc sources

Output

**TODO**
```

### Install `client01`

- Confirm your NTP server configuration by manual time sync from `client01`. Use `ntpdate`.

```bash
ntpdate 172.22.100.10
```

- SSH into `client01` and repeat all steps from `Install server01`, EXCEPT setting Chrony to act like a server.

(repeat steps in `server01`)

- Turn Chronyc into a NTP client by pointing to NTP server in file `/etc/chrony.conf`

```bash
server 172.22.100.10
```

- Restart Chrony NTP daemon to apply the changes

```bash
systemctl restart chronyd
```

- Check for NTP server sources. Your local NTP server should be listed

```bash
chronyc sources
```

### `server01`

- SSH into ntp server and list the ntp clients

```bash
chronyc clients
```

## Extra

- Add client02 to sync with the server

## Link

[Manage ntp chrony](https://opensource.com/article/18/12/manage-ntp-chrony)
[Configuring NTP using the Chrony Suite](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/system_administrators_guide/ch-configuring_ntp_using_the_chrony_suite)
