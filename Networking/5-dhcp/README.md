# Lab - DHCP

## Description

DHCP stands for dynamic host configuration protocol and is a network protocol used on IP networks where a DHCP server automatically assigns an IP address and other information to each host on the network so they can communicate efficiently with other endpoints.

## Prerequisites

none

## Objectives

- Setup a DHCP server on `server01`
- Configure `client01` from dhcp to have a static IP address

## Software

dhcp

## Vagrant

Network: `172.22.100.0/24`

Creates two VMs
`server01 172.22.100.10`
`client01 dhcp`

## TODO

### Missing IP address on interface `eth1`on client

- The interface `eth1`on the client does not have an IP address (no inet), ssh into the client machine and verify it

- Try to ping the server, no packages will be delivered

### Install DHCP server package on the server

- SSH into the server. Verify that the server has the IP `172.22.100.10`

- Download and cache in binary format metadata for all known repos

- Install DHCP server package

#### Configure DHCP server

- Edit the configuration file `/etc/dhcp/dhcpd.conf` and add following configuration

```bash
default-lease-time 600;
max-lease-time 7200;

ddns-update-style none;
authoritative;

subnet 172.22.100.0 netmask 255.255.255.0 {
    range 172.22.100.15 172.22.100.200;
    option routers 172.22.100.1;
}
```

- Start DHCP service

- Check status

- Add the dhcpd service to the system startup, automatically start the dhcpd service on boot

#### Configure firewall

- Enable firewalld

- Start firewalld

- Check the Status of firewalld

- Allow access to the DHCP server

- Reload for the changes to take effect

### Client has now got an IP address

You have configured a DHCP server in previous steps and it should be working.

- The client is pre-configured with dhcp on interface `eth1` and should have an IP address assigned to it. SSH to the client and verify it.

#### Assign a static IP on `eth1`

- Using **nmcli**, change IP address to `172.22.100.150`, gateway `172.22.100.1`, dns `172.22.100.1` setting on interface `eth1` (name is `Wired connection 1`) and change the method to `manual`

*TIPS! Use tab to find the commands and names*

- Activate the new settings

- Verify that it is removed

## Answers / Guide

### Missing IP address on interface `eth1`on client

- The interface `eth1`on the client does not have an IP address (no inet), ssh into the client machine and verify it

```bash
ip a

Output

3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:25:3e:70 brd ff:ff:ff:ff:ff:ff
    inet6 fe80::c25a:be39:f456:1364/64 scope link noprefixroute
       valid_lft forever preferred_lft forever
```

- Try to ping the server, no packages will be delivered

```bash
ping -c3 173.22.100.10
```

### Install DHCP server package on the server

- SSH into the server. Verify that the server has the IP `172.22.100.10`

```bash
ip a

Output

3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
...
    inet 172.22.100.10/24 brd 172.22.100.255 scope global noprefixroute eth1
...
```

- Download and cache in binary format metadata for all known repos

```bash
dnf makecache
```

- Install DHCP server package

```bash
dnf install dhcp-server
```

#### Configure DHCP server

- Edit the configuration file `/etc/dhcp/dhcpd.conf` and add following configuration

```bash
default-lease-time 600;
max-lease-time 7200;

ddns-update-style none;
authoritative;

subnet 172.22.100.0 netmask 255.255.255.0 {
    range 172.22.100.10 172.22.100.200;
    option routers 172.22.100.1;
}
```

The DHCP server will reserve the IP address for at least 600 seconds or 10 minutes `default-lease-time` and at max 7200 seconds or 2 hours `max-lease-time` for a specific device

The DHCP configuration for the network `subnet` is 172.22.100.0/24

`range` defines the assignable IP address range of the DHCP pool

`routers` defines the default gateway

- Start DHCP service

```bash
systemctl start dhcpd
```

- Check status

```bash
systemctl status dhcpd
```

- Add the dhcpd service to the system startup, automatically start the dhcpd service on boot

```bash
systemctl enable dhcpd
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

- Check the Status of firewalld

```bash
systemctl status firewalld
```

- Allow access to the DHCP server

```bash
firewall-cmd --add-service=dhcp --permanent
```

- Reload for the changes to take effect

```bash
firewall-cmd --reload
```

### Client has now got an IP address

You have configured a DHCP server in previous steps and it should be working.

- The client is pre-configured with dhcp on interface `eth1` and should have an IP address assigned to it. SSH to the client and verify it.

```bash
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:2f:ae:65 brd ff:ff:ff:ff:ff:ff
    inet 172.22.100.17/24 brd 172.22.100.255 scope global dynamic noprefixroute eth1
       valid_lft 369sec preferred_lft 369sec
    inet6 fe80::4c76:2709:623b:ca4e/64 scope link noprefixroute
       valid_lft forever preferred_lft forever
```

..you can see the `inet..` row now exist with an IP address and `dynamic`

#### Assign a static IP on `eth1`

- Using **nmcli**, change IP address to `172.22.100.150`, gateway `172.22.100.1`, dns `172.22.100.1` setting on interface `eth1` (name is `Wired connection 1`) and change the method to `manual`

*TIPS! Use tab to find the commands and names*

```bash
nmcli connection modify Wired\ connection\ 1 IPv4.address 172.22.100.150/24 IPv4.gateway 172.22.100.1 IPv4.dns 172.22.100.1 ipv4.method manual
```

- Activate the new settings

```bash
nmcli connection up Wired\ connection\ 1
```

- Verify that it is removed

```bash
ip a sh eth1
```

## Extra

- Setup client02 and configure the network interfaces

## Link

[DHCP Servers](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/networking_guide/ch-dhcp_servers)
