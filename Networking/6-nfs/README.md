# Lab - NFS

## Description

A network file system enables local users to access remote data and files in the same way they are accessed locally.

## Prerequisites

none

## Objectives

- Set up an NFS server on `server01`
- Manual mount file system to `client01`
- Automount file system to `client01`

## Software

nfs

## Vagrant

Network: `172.22.100.0/24`

Creates three VMs
`server01 172.22.100.10`
`client01 172.22.100.20`
`client02 172.22.100.30`

## TODO

### Setup NFS Server

#### Install NFS

- Download and cache in binary format metadata for all known repos

- Install `nfs-utils` package

- Start nfs server service

- Enable it to automatically start at system boot

- Verify its status

The services that are required for running an NFS server or mounting NFS shares: **nfsd**, **nfs-idmapd**, **rpcbind**, **rpc.mountd**, **lockd**, **rpc.statd**, **rpc.rquotad**, and **rpc.idmapd** will be automatically started

Configuration files for the NFS server:

**/etc/nfs.conf** - main configuration file for the NFS daemons and tools

**/etc/nfsmount.conf** - an NFS mount configuration file

#### Create NFS shares

- Create shares `/srv/nfs_shares/{docs,backups}`

- Add content in the directories

- Set owner to `nobody` and full permission too all. This is to avoid encountering any permission issues from the client systems

- Restart NFS daemon

#### Export NFS shares

- Export created files in NFS server `/etc/exports` configuration file.

- Run `exportfs` command with the `-a` flag means export or unexport all directories, `-r` means reexport all directories, synchronizing `/var/lib/nfs/`etab with /etc/exports and files under `/etc/exports.d`, and `-v` enables verbose output

- Display the current export list. Some of the default exports options that are not explicitly defined will be shown

#### Configure firewall

- Enable firewalld

- Start firewalld

- Check the status of firewalld

- Allow access to the NFS services `mountd`, `nfs` and `rpc-bind`

- Reload for the changes to take effect

### Setup NFS Client

#### Install NFS client

- Download and cache in binary format metadata for all known repos

- Install `nfs-utils` and `nfs4-acl-tools`

- Use `showmount` command to show mount information for the NFS server

#### Mount NFS server

- Create a mounting directory to mount the remote NFS file system

- Mount `/mnt/nfs_shares/docs` as an nfs file system

- Try and mount `mnt/nfs_shares/backups`. It will fail due to it being only accessible on `client02`

- Confirm that the remote file system has been mounted by running

- Enable persistent mount after reboot

- Verify that `test_file.txt` exist in `/mnt/docs`

- Create a file in `/mnt/docs`

#### Verify created file on NFS Server

- Lookin to the `/mnt/nfs_shares/docs` to verify that the `from_client.txt` from client has been added

## Guide / answers

### Setup NFS Server

#### Install NFS

- Download and cache in binary format metadata for all known repos

```bash
dnf makecache
```

- Install `nfs-utils` package

```bash
dnf install nfs-utils
```

- Start nfs server service

```bash
systemctl start nfs-server
```

- Enable it to automatically start at system boot

```bash
systemctl enable nfs-server
```

- Verify its status

```bash
systemctl status nfs-server
```

The services that are required for running an NFS server or mounting NFS shares: **nfsd**, **nfs-idmapd**, **rpcbind**, **rpc.mountd**, **lockd**, **rpc.statd**, **rpc.rquotad**, and **rpc.idmapd** will be automatically started

Configuration files for the NFS server:

**/etc/nfs.conf** - main configuration file for the NFS daemons and tools

**/etc/nfsmount.conf** - an NFS mount configuration file

#### Create NFS shares

- Create shares `/srv/nfs_shares/{docs,backups}`

```bash
mkdir -p  /srv/nfs_shares/{docs,backups}
```

- Add content in the directories

```bash
touch /srv/nfs_shares/{docs,backups}/test_file.txt
```

- Set owner to `nobody` and full permission too all. This is to avoid encountering any permission issues from the client systems

```bash
chown -R nobody: /srv/nfs_shares/{docs,backups}
chmod 777 /srv/nfs_shares/{docs,backups}
```

- Restart NFS daemon

```bash
systemctl restart nfs-utils
```

#### Export NFS shares

- Export created files in NFS server `/etc/exports` configuration file.

```bash
/srv/nfs_shares/docs        172.22.100.0/24(rw,sync,no_all_squash,root_squash)
/srv/nfs_shares/backups     172.22.100.30(rw,sync,no_all_squash,root_squash)
```

- Run `exportfs` command with the `-a` flag means export or unexport all directories, `-r` means reexport all directories, synchronizing `/var/lib/nfs/`etab with /etc/exports and files under `/etc/exports.d`, and `-v` enables verbose output

```bash
exportfs -arv
```

- Display the current export list. Some of the default exports options that are not explicitly defined will be shown

```bash
exportfs  -s
```

From `man exports`:

**rw** – allows both read and write access on the file system.

**sync** – tells the NFS server to write operations (writing information to the disk) when requested (applies by default).

**all_squash** – maps all UIDs and GIDs from client requests to the anonymous user.

**no_all_squash** – used to map all UIDs and GIDs from client requests to identical UIDs and GIDs on the NFS server.

**root_squash** – maps requests from root user or UID/GID 0 from the client to the anonymous UID/GID.

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

- Allow access to the NFS services `mountd`, `nfs` and `rpc-bind`

```bash
firewall-cmd --permanent --add-service=mountd
firewall-cmd --permanent --add-service=nfs
firewall-cmd --permanent --add-service=rpc-bind
```

- Reload for the changes to take effect

```bash
firewall-cmd --reload
```

### Setup NFS Client

#### Install NFS client

- Download and cache in binary format metadata for all known repos

```bash
dnf makecache
```

- Install `nfs-utils` and `nfs4-acl-tools`

```bash
dnf install nfs-utils nfs4-acl-tools
```

- Use `showmount` command to show mount information for the NFS server

```bash
showmount -e 172.22.100.10
```

#### Mount NFS server

- Create a mounting directory to mount the remote NFS file system

```bash
mkdir -p /mnt/{docs,backups}
```

- Mount `/srv/nfs_shares/docs` as an nfs file system

```bash
mount -t nfs  172.22.100.10:/srv/nfs_shares/docs /mnt/docs
```

- Try and mount `/srv/nfs_shares/backups`. It will fail due to it being only accessible on `client02`

```bash
mount -t nfs  172.22.100.10:/srv/nfs_shares/backups /mnt/backups

Output:
mount.nfs: mounting 172.22.100.10:/srv/nfs_shares/backups failed, reason given by server: No such file or directory
```

- Confirm that the remote file system has been mounted by running

```bash
mount | grep nfs
```

- Enable persistent mount after reboot

```bash
echo "172.22.100.10:/srv/nfs_shares/docs   /mnt/docs  nfs     defaults 0 0">>/etc/fstab
```

- Verify that `test_file.txt` exist in `/mnt/docs`

```bash
ls -l /mnt/docs
```

- Create a file in `/mnt/docs`

```bash
touch /mnt/docs/from_client.txt
```

#### Verify created file on NFS Server

- Lookin to the `/srv/nfs_shares/docs` to verify that the `from_client.txt` from client has been added

```bash
ls -l /srv/nfs_shares/docs
```

## Extra

- Configure `client02` like `client01` but remember to mount the `backups` also
- You can control access with IP and file permissions. Play around with it. You can change IP, create users, and set file permissions.

## Link

--
