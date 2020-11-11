# Lab - Basic Networking

## Description

Gain some muscle memory with the basic network toolkit. It is fundamental skills to have when working with Linux systems.

## Prerequisites

Basic Linux 1 knowledge

## Objectives

Recap basic networking commands

## Software

ping

hostname

ip / ifconfig

tracepath / traceroute

ss / netstat

nmncli

## Vagrant

Creates a VM

`client01 172.22.100.20`

## Always start with update in a new machine

```bash
dnf makecache
dnf repolist --enabled
```

## TODO

### Examining Network Configuration

- Display the current IP address and netmask for all interfaces

- Display the statics for the eth0

- Display routing information

- Verify that the router is accessible

- Use `tracepath` to trace hops between the local system and google.com

- Install `traceroute` and trace hops between the local system and google.com

- Ping internet (any DNS) ex. `8.8.8.8`

### Configure Networking with `nmcli`

- View network setting using `nmcli`

- Display configuration setting for active connection

- Take a look at the output and think for yourself what they mean

```bash
...
IP4.ADDRESS
IP4.GATEWAY
IP4.ROUTE
IP4.DNS
IP4.DOMAIN
...
```

- Show device status

- Display the settings for `eth0` device

### Configure hostnames and name resolution

- Display current hostname

- Display the hostname status

--

- Set a static hostname, to `machine01`

- View the configuration file that provides the hostname at network start

- Display hostname status

--

- Temporary change the hostname

- Display current hostname

- View the configuration file providing the hostname at network start

- Reboot the system. The temporary hostname should not longer be there

### Network Communication

#### Use `ss`

- List all UDP and TCP sockets

- List all sockets using TCP/IP4

- List TCP connections that the state is established

- List TCP connections that the is are listening

- See which processes are using the sockets (hint! you need to to use `sudo`)

#### Use `netstat`

- Display all UDP and TCP port connections

- Display all active listening UDP and TCP ports

- Display the kernel route table and display numeric information only

- Show Kernel interface table

## Commands (hints)

**Examining Network Configuration**

```bash
ip
ping
tracepath
```

**Configure Networking with `nmcli`**

Use the tab command and also `man nmcli`

**Configure hostnames and name resolution**

```bash
hostname
```

**Network Communication**

```bash
ss
netstat
```

## Answers / Guided

### Examining Network Configuration

- Display the current IP address and netmask for all interfaces

```bash
ip addr
```

- Display the statics for the eth0

```bash
ip -s link show eth0
```

- Display routing information

```bash
ip route
```

- Verify that the router is accessible

*Output can variate but will be visible after row `default via..`*

```bash
ping -c3 x.x.x.x
```

- Use `tracepath` to trace hops between the local system and google.com

```bash
tracepath google.com
```

- Install `traceroute` and trace hops between the local system and google.com

```bash
sudo dnf install traceroute
...
traceroute google.com
```

- Ping internet (any DNS) ex. `8.8.8.8`

```bash
ping -c3 8.8.8.8
```

### Configure Networking with `nmcli`

- View network setting using `nmcli`

```bash
nmcli con show
```

- Display configuration setting for active connection

```bash
nmcli con show eth0
```

- Take a look at the output and think for yourself what they mean

```bash
...
IP4.ADDRESS
IP4.GATEWAY
IP4.ROUTE
IP4.DNS
IP4.DOMAIN
...
```

- Show device status

```bash
nmcli dev status
```

- Display the settings for `eth0` device

```bash
nmcli dev show eth0
```

*The settings are shown again as you can see*

### Configure hostnames and name resolution

- Display current hostname

```bash
hostname
```

- Display the hostname status

```bash
hostnamectl status
```

--

- Set a static hostname, to `machine01`

```bash
sudo hostnamectl set-hostname machine01
```

- View the configuration file that provides the hostname at network start

```bash
cat /etc/hostname
```

- Display hostname status

```bash
hostnamectl status
```

--

- Temporary change the hostname

```bash
sudo hostname tempmachine02
```

- Display current hostname

```bash
hostname
```

- View the configuration file providing the hostname at network start

```bash
cat /etc/hostname
```

- Reboot the system. The temporary hostname should not longer be there

*You can reboot you machine to verify that the temporary hostname is gone*

### Network Communication

#### Use `ss`

- List all UDP and TCP sockets

```bash
ss -aut
```

- List all sockets using TCP/IP4

```bash
ss -a4
```

- List TCP connections that the state is established

```bash
ss -t -r state established
```

- List TCP connections that the is are listening

```bash
ss -t -r state listening
```

- See which processes are using the sockets (hint! you need to to use `sudo`)

```bash
sudo ss -t -p
```

#### Use `netstat`

- Display all UDP and TCP port connections

```bash
netstat -aut
```

- Display all active listening UDP and TCP ports

```bash
netstat -lup
```

- Display the kernel route table and display numeric information only

```bash
netstat -rn
```

- Show Kernel interface table

```bash
netstat -ie
```

## Extra

Google other other networking tools and play around with them

## Links

--
