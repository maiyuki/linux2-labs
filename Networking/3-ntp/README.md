# Lab - NTP

## Description

A networking protocol for clock synchronization between computer systems. Chrony is a default NTP client as well as an NTP server on RHEL 8 / CentOS 8.

## Prerequisites

none

## Objectives

- Setup an NTP server on `server01`
- Configure `client01` to sync its time to `server01`

## Software

chrony (chrony)

## Vagrant

Creates two VMs
`server01 172.22.100.10`
`client01 172.22.100.20`

## TODO

### Install NTP server

- Install Chrony NTP:

- Enable chrony to start after boot:

- Set Chrony to act as an NTP server for the local network. Edit file `/etc/chrony.conf`

- Restart Chrony NTP daemon to apply the changes

- Open firewall port to allow for incoming NTP requests

- Check chrony sources

### Install NTP client

- Confirm your NTP server configuration by manual time sync from `client01`. Use `ntpdate`.

- SSH into `client01` and repeat all steps from `Install server01`, EXCEPT setting Chrony to act like a server.

- Turn Chronyc into a NTP client by pointing to NTP server in file `/etc/chrony.conf`

- Restart Chrony NTP daemon to apply the changes

- Check for NTP server sources. Your local NTP server should be listed

### Verify connection on NTP server

- SSH into ntp server and list the ntp clients

## Answers / Guide

### Install NTP server

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

- Check chrony sources (you might see different sources)

```bash
chronyc sources
...
Output (example)

210 Number of sources = 4
MS Name/IP address         Stratum Poll Reach LastRx Last sample
===============================================================================
^+ ntp6.flashdance.cx            2   6    17    18  -1816us[-2053us] +/-   38ms
^* ntp-d.0x5e.se                 2   6    17    17   +878us[ +641us] +/-   28ms
^+ ntp3.flashdance.cx            2   6    17    18    +49us[ -188us] +/-   45ms
^? ntp-c.0x5e.se                 0   6     0     -     +0ns[   +0ns] +/-    0ns

```

### Install NTP client

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

Output (example):

210 Number of sources = 5
MS Name/IP address         Stratum Poll Reach LastRx Last sample
===============================================================================
^? 172.22.100.10                 0   6     0     -     +0ns[   +0ns] +/-    0ns
...
```

### Verify connection on NTP server

- SSH into ntp server and list the ntp clients

*(It might take some time for it to sync)*

```bash
chronyc clients

Outupt:

Hostname                      NTP   Drop Int IntL Last     Cmd   Drop Int  Last
===============================================================================
172.22.100.20                   5      0   6   -    64       0      0   -     -
```

## Extra

- Add client02 to sync with the server
- Set Time, Timezone and Synchronize System Clock `timedatectl`on `client01`

## Link

[Manage ntp chrony](https://opensource.com/article/18/12/manage-ntp-chrony)
[Configuring NTP using the Chrony Suite](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/system_administrators_guide/ch-configuring_ntp_using_the_chrony_suite)
