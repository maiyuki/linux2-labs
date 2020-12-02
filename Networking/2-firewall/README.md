# Lab - Firewall

## Description

Firewall is a important part in the Linux system and also a knowledge that will make your life easier if it say rock solid in the tip of your fingers.

## Prerequisites

Basic firewall knowledge from Linux 1

## Objectives

Learn how to use `firewalld` and commands

## Software

firewalld

## Vagrant

Creates a VM

`server01 172.22.100.10`

## TODO

### Limiting Network Communication

#### Use `firewalld`

##### Installing and enabling firewalld

- Verify that `firewalld` is running

- If not, enable `firewalld`

- Start `firewalld`

- Again, verify that `firewalld` is running

##### Current Firewall Rules

*Default zone*

- Check what the default zone is

- Get the active zones

- List all configuration applied to the zone

*Other zones*

- Get a list of the available zones, `home` should be included to the list

- List all configuration applied to the `home` zone

#### Selecting Zones for your Interfaces

- As you can see, the default zone has `eth1` configured on the `interfaces`. Let's move it `eth1` to zone `home` `interfaces`

- Verify this by listing the active zones again

- Change default zone to home

- Verify that it has been changed

#### Setting Rules for your Applications

##### Adding a Service to your Zones

- First list of the available service

- `http` should be available on the list, explore more details of `http` in `/usr/lib/firewalld/services`

- Add `http` to the `public` zone

- Verify it was successful added

- Add `http` permanent to the `public` zone so that it still will be available after a reboot

- Verify it was successful added, permanent

## Commands (hints)

**Limiting Network Communication**

```bash
firewalld
```

## Answers / Guide

### Limiting Network Communication

#### Use `firewalld`

##### Installing and enabling firewalld

- Verify that `firewalld` is running

```bash
firewall-cmd --state
```

- If not, enable `firewalld`

```bash
systemctl status firewalld
```

- Start `firewalld`

```bash
systemctl start firewalld
```

- Again, verify that `firewalld` is running

```bash
systemctl status firewalld
```

##### Current Firewall Rules

*Default zone*

- Check what the default zone is

```bash
firewall-cmd --get-default-zone
```

- Get the active zones

```bash
firewall-cmd --get-active-zones
```

- List all configuration applied to the zone

```bash
firewall-cmd --list-all
```

*Other zones*


- Get a list of the available zones, `home` should be included to the list

```bash
firewall-cmd --get-zones
```

- List all configuration applied to the `home` zone

```bash
firewall-cmd --zone=home --list-all
```

#### Selecting Zones for your Interfaces

- As you can see, the default zone has `eth1` configured on the `interfaces`. Let's move it `eth1` to zone `home` `interfaces`

```bash
firewall-cmd --zone=home --change-interface=eth1
```

- Verify this by listing the active zones again

```bash
firewall-cmd --get-active-zones
```

- Change default zone to home

```bash
firewall-cmd --set-default-zone=home
```

- Verify that it has been changed

```bash
firewall-cmd --get-default-zone
```

#### Setting Rules for your Applications

##### Adding a Service to your Zones

- First list of the available service

```bash
firewall-cmd --get-services
```

- `http` should be available on the list, explore more details of `http` in `/usr/lib/firewalld/services`

```bash
less /usr/lib/firewalld/services/http.xml
```

- Add `http` to the `public` zone

```bash
firewall-cmd --zone=public --add-service=http
```

- Verify it was successful added

```bash
firewall-cmd --zone=public --list-services
```

- Add `http` permanent to the `public` zone so that it still will be available after a reboot

```bash
firewall-cmd --zone=public --add-service=http --permanent
```

- Verify it was successful added, permanent

```bash
firewall-cmd --zone=public --list-services --permanent
```

## Extra

In CentOS 8, `iptables` is replaced by `nftables` as the default firewall backend for the firewalld daemon.

https://netfilter.org/projects/nftables/

## Links

--
