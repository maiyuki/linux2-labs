# Lab - DNS

## Description

DNS is the phone book of the Internet.

## Prerequisites

none

## Objectives

- Setup an DNS server on `server01`
- Configure `client01` to sync to `server01`, verify it

## Software

bind (also called named)

## Vagrant

Network: `172.22.100.0/24`

Creates two VMs
`server01 172.22.100.10`
`client01 172.22.100.20`

## TODO

### Install DNS server

#### Install packages

- Download and cache in binary format metadata for all known repos

```bash
dnf makecache
```

- Install bind and bind-utils package

```bash
dnf install bind bind-utils
```

- Start DNS Server

```bash
systemctl start named
```

- Enable named at reboot

```bash
systemctl enable named
```

- Make sure named service is running

```bash
systemctl status named
```

### Configure bind DNS server

Edit file `/etc/named.conf`:

- Under the `Options` section, comment out the lines `listen-on...` and `listen-on-v6...` to enable the Bind DNS server to listen to all IPs

```bash
// listen-on port 53 { 127.0.0.1; };
// listen-on-v6 port 53 { ::1; };
```

- Locate `allow-query...`and adjust to the network subnet. This setting allows only the hosts in the defined network to access the DNS server and not just any other host.

```bash
allow-query { localhost; 172.22.100.0/24; };
```

A forward lookup DNS zone is one that stores the host name ip address relationship. When queried, it gives the IP address of the host system using the host name. In contrast, the reverse DNS zone returns the Fully Qualified Domain Name (FQDN) of the server in relation to it’s IP address.

- Define the reverse and forward lookup zones. Copy these lines and add to the end of `/etc/named.conf`

```bash
//forward zone (A rules - domain to IP address)
zone "server01.local" IN {
     type master;
     file "server01.local.db";
     allow-update { none; };
     allow-query { any; };
};

//backward zone (A rules - IP address to domain)
zone "100.22.172.in-addr.arpa" IN {
     type master;
     file "server01.local.rev";
     allow-update { none; };
     allow-query { any; };
};
```

**type:** Decides the role of the server for a particular zone. the attribute ‘master’ implies that this is an authoritative server.
**file:** Points to the forward / reverse zone file of the domain.
**allow-update:** This attribute defined the host systems which are permitted to forward Dynamic DNS updates. In this case, we don’t have any.

### Create a forward DNS zone file for the domain

- Create a forward DNS zone file for domain server01.local. Create file `/var/named/server01.local.db` and add content below:

```bash
$TTL 86400
@ IN SOA my-dns.server01.local. admin.server01.local. (
                                                2020011800 ;Serial
                                                3600 ;Refresh
                                                1800 ;Retry
                                                604800 ;Expire
                                                86400 ;Minimum TTL
)

;Name Server Information
@ IN NS my-dns.server01.local.

;IP Address for Name Server
my-dns IN A 172.22.100.10

;Mail Server MX (Mail exchanger) Record
server01.local. IN MX 10 mail.server01.local.

;A Record for the following Host name
www  IN   A   172.22.100.30
mail IN   A   172.22.100.40

;CNAME Record
ftp  IN   CNAME www.server01.local.
```

**TTL:** This is short for Time-To-Live. TTL is the duration of time (or hops) that a packet exists in a network before finally being discarded by the router.
**IN:** This implies the Internet.
**SOA:** This is short for the Start of Authority. Basically, it defines the authoritative name server, in this case, my-dns.server01.local and contact information – admin.server01.local
**NS:** This is short for Name Server.
**A:** This is an A record. It points to a domain/subdomain name to the IP Address
**Serial:** This is the attribute used by the DNS server to ensure that contents of a specific zone file are updated.
**Refresh:** Defines the number of times that a slave DNS server should transfer a zone from the master.
**Retry:** Defines the number of times that a slave should retry a non-responsive zone transfer.
**Expire:** Specifies the duration a slave server should wait before responding to a client query when the Master is unavailable.
**Minimum:** This is responsible for setting the minimum TTL for a zone.
**MX:** This is the Mail exchanger record. It specifies the mail server receiving and sending emails
**CNAME:** This is the Canonical Name. It maps an alias domain name to another domain name.
**PTR:** Short for Pointer, this attributes resolves an IP address to a domain name, opposite to a domain name.

### Create a reverse DNS zone file for the domain

- Create a reverse DNS lookups. Create file `/var/named/server01.local.rev` and add content below:

```bash
$TTL 86400
@ IN SOA my-dns.server01.local. admin.server01.local. (
                                            2020011800 ;Serial
                                            3600 ;Refresh
                                            1800 ;Retry
                                            604800 ;Expire
                                            86400 ;Minimum TTL
)
;Name Server Information
@ IN NS my-dns.server01.local.
my-dns     IN      A       172.22.100.10

;Reverse lookup for Name Server
10      IN      PTR     my-dns.server01.local.

;PTR Record IP address to Hostname
50      IN      PTR     www.server01.local.
60      IN      PTR     mail.server01.local.
```

- Assign the necessary file permissions to the two configuration files

```bash
chown named:named /var/named/server01.local.db
chown named:named /var/named/server01.local.rev
```

- Confirm that the DNS zone lookup files are free from any syntactical errors, run the commands shown:

```bash
named-checkconf

named-checkzone server01.local /var/named/server01.local.db
Output: OK

named-checkzone 100.22.172.in-addr.arpa /var/named/server01.local.rev
Output: OK
```

- Restart bind

```bash
systemctl restart named
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

- Configuring the Firewall - enable the DNS service and reload

```bash
firewall-cmd --permanent --zone=public --add-service=dns
```

- Reload configuration

```bash
firewall-cmd --reload
```

### Install DNS client

- Append Bind DNS server's IP address in `/etc/sysconfig/network-scripts/ifcfg-eth1`

```bash
...
DNS1=172.22.100.10
```

- Restart network manager

```bash
systemctl restart NetworkManager
```

- Install dig & nslookup

```bash
dnf install bind-utils
```

- Use the nslookup command test the Bind DNS. The output from the nslookup command confirms that the forward DNS lookup is working as expected.

```bash
nslookup my-dns.server01.local
nslookup mail.server01.local
nslookup www.server01.local
nslookup ftp.server01.local
nslookup 172.22.100.10
```

- Use the dig command

```bash
dig my-dns.server01.local
dig -x 172.22.100.10 # reverse DNS lookup
```

___?
- Configuring the Firewall as explained above with the server.

- Resolver configuration. The first nameserver must be our server DNS, also here make sure the Network Manager doesn`t alter the resolv.conf file.

- Setting the Hostname. For consistency any client in the domain would have a FQDN hostname assigned.

- Verify DNS configuration. Ping the server by name.

???---
## Extra

- Add client02 to sync with the server

## Link

[DNS Server Type](https://www.cloudflare.com/en-gb/learning/dns/dns-server-types/)
[What is 1.1.1.1](https://www.cloudflare.com/en-gb/learning/dns/what-is-1.1.1.1)
