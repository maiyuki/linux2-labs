# Lab - Schedule Job using Cron

## Description

Job scheduling is an important skill to master as a Linux Administrator. Job scheduling is a feature that allows a user to submit a command or program for execution at a specified time in the future. A backup of a database is common which we will install in this lab. Backups are useless if we cannot do a restore. A restore will be set up also.

## Prerequisites

[Vagrant](https://www.vagrantup.com/downloads)

[Virtualbox](https://www.virtualbox.org/wiki/Downloads)

## Software

Crontab

MySQL

## Vagrant

Creates one VM:

`db01 172.22.100.10`

## TODO

### Configure database machine

- Download and cache in binary format metadata for all known repos

#### Install MySQL

- Download and install mysql on `db01`

- Start MySQL

- Verify that MySQL service is working

- Set MySQL to start whenever the server boots up

#### Secure MySQL installation and verify installation

- Run secure installation command for mysql to clean up in the database

*This will take you through a series of prompts asking if you want to make certain changes to your MySQL installation’s security options. It will also ask if you want to set a password. Set example* `mysupersecretp@ssword!`

- Use `mysqladmin` to verify your installation (it will prompt you for the password if you have set it in the secure installation)

#### Add data to MySQL

- Connect to `mysql`

- Create a database

- Verify that it is created

- Select/use the database

- Create a table

- Verify that the table is created

- Describe the table

### Do a test backup and a test restore

#### Prepare for backup

- Create a mysql option file `~/.mysql/mysql.cnf`

```bash
[mysqldump]
host = localhost
user = root
password = "mysupersecretp@ssword!"
```

- Make sure only root has read and write access to the file

- ..and read, write and execute on the directory

#### Create a backup

- Use `mysqldump` client utility to create a backup of the database to the `/tmp` directory

*Add the flag: `--defaults-extra-file=~/.mysql/mysql.cnf` We do not want to expose our credentials in the process*

- Verify that is succeeded

#### Remove data

- Remove the database

- Verify that the database has been removed

#### Restore the database

- Because the restore is of one single database, a new one has to be created. Use `mysqladmin`

- Restore database from the backup

- Verify that database has been restored

- Show tables

- Describe the table

### Add a backup script

#### Add script

- Add backup script to `/root/bin/backup-bookstore-mysql`

- Make file executable

#### Schedule task with crontab

- Schedule backup task to execute at `2 am` daily `/etc/crontab`

#### Test crontab

- Clean up in `/tmp`

- Add `time` in filename in `/root/bin/backup-bookstore-mysql`

- Change in the `/etc/crontab` from `daily at 2 am` to `every 2 min`

*...wait*

- Verify that the crontab works

*Restore changes in file*

### Add a restore program

#### Add restore script

- Add a restore script to `/usr/local/bin/mysqlrestore`

- Make file executable

- Create a symlink to `/root/bin/mysqlrestore`. The `PATH` is pointing to `/root/bin/` directory

### Test restore program

- Delete database

- Recreate database

*(You need an empty database to do a restore)*

- Run the restore script

- Verify that the database is restored

## Answers / Guide

### Configure database machine

- Download and cache in binary format metadata for all known repos

```bash
dnf makecache
```

#### Install MySQL

- Download and install mysql on `db01`

```bash
dnf install mysql-server
```

- Start MySQL

```bash
systemctl start mysqld
```

- Verify that MySQL service is working

```bash
systemctl status mysqld
```

- Set MySQL to start whenever the server boots up

```bash
systemctl enable mysqld
```

#### Secure MySQL installation and verify installation

- Run secure installation command for mysql to clean up in the database

*This will take you through a series of prompts asking if you want to make certain changes to your MySQL installation’s security options. It will also ask if you want to set a password. Set example* `mysupersecretp@ssword!`

```bash
mysql_secure_installation
```

- Use `mysqladmin` to verify your installation (it will prompt you for the password if you have set it in the secure installation)

```bash
mysqladmin -u root -p version
```

#### Add data to MySQL

- Connect to `mysql`

```bash
mysql -u root -p
```

- Create a database

```bash
mysql> CREATE DATABASE bookstore;
```

- Verify that it is created

```bash
mysql> SHOW DATABASES;
```

- Select/use the database

```bash
mysql> USE bookstore;
```

- Create a table

```bash
mysql> CREATE TABLE customers
(
id int auto_increment primary key,
first_name varchar(500) NOT null,
last_name varchar(500) NOT null,
address varchar(1000),
email varchar(500),
phone int default 10
);
```

- Verify that the table is created

```bash
mysql> SHOW TABLES;
```

- Describe the table

```bash
mysql> DESCRIBE customers;
```

### Do a test backup and a test restore

#### Prepare for backup

- Create a mysql option file `~/.mysql/mysql.cnf`

```bash
[mysqldump]
host = localhost
user = root
password = "mysupersecretp@ssword!"
```

- Make sure only root has read and write access to the file

```bash
chmod 600 ~/.mysql/mysql.cnf
```

- ..and read, write and execute on the directory

```bash
chmod 700 ~/.mysql
```

#### Create a backup

- Use `mysqldump` client utility to create a backup of the database to the `/tmp` directory

*Add the flag: `--defaults-extra-file=~/.mysql/mysql.cnf` We do not want to expose our credentials in the process*

```bash
mysqldump --defaults-extra-file=~/.mysql/mysql.cnf bookstore > /tmp/bookstore-full-backup-$(date +%F).sql
```

- Verify that is succeeded

```bash
ls -l /tmp | grep backup
```

#### Remove data

- Remove the database

```bash
mysql> drop DATABASE bookstore;
```

- Verify that the database has been removed

```bash
mysql> SHOW DATABASES;
```

#### Restore the database

- Because the restore is of one single database, a new one has to be created. Use `mysqladmin`

```bash
mysqladmin -u root -p CREATE bookstore;
```

- Restore database from the backup. Change `<date>` to the correct date.

```bash
mysql -u root -p bookstore < /tmp/bookstore-full-backup-<date>.sql
```

- Verify that database has been restored

```bash
mysql> SHOW DATABASES;
```

- Show tables

```bash
mysql> SHOW TABLES;
```

- Describe the table

```bash
mysql> DESCRIBE customers;
```

### Add a backup script

#### Add script

- Add backup script to `/root/bin/backup-bookstore-mysql`

```bash
#!/bin/bash

DATE=$(date +%F)

mysqldump --defaults-extra-file=~/.mysql/mysql.cnf bookstore > /tmp/bookstore-full-backup-$DATE.sql

EXITVALUE=$?
if [ $EXITVALUE != 0 ]; then
    /usr/bin/logger -t logrotate "ALERT exited with [$EXITVALUE]"
fi
exit $EXITVALUE
```

- Make file executable

```bash
chmod +x /root/bin/backup-bookstore-mysql
```

#### Schedule task with crontab

- Schedule backup task to execute at `2 am` daily `/etc/crontab`

```bash
...
0 2 * * * root bash /root/bin/backup-bookstore-mysql
...
```

#### Test crontab

- Clean up in `/tmp`

```bash
rm -rf /tmp/bookstore-full-backup-<date>.sql
```

- Add `time` in filename in `/root/bin/backup-bookstore-mysql`

```bash
...
DATE=$(date +%F-%T)

mysqldump --defaults-extra-file=~/.mysql/mysql.cnf bookstore > /tmp/bookstore-full-backup-$DATE.sql
...
```

- Change in the `/etc/crontab` from `daily at 2 am` to `every 2 min`

```bash
...
*/2 * * * * root bash /root/bin/backup-bookstore-mysql
```

*...wait*

- Verify that the crontab works

```bash
ls -l /tmp | grep backup
```

*Restore changes in file*

### Add a restore program

#### Add restore script

- Add a restore script to `/usr/local/bin/mysqlrestore`

```bash
#!/bin/bash

ARG=$1
LOCATION="/tmp"
PREFIX="bookstore-full-backup-"

if [ ! -z $ARG ]; then

  FILENAME=$LOCATION/$PREFIX$ARG.sql
  EXIST=$(ls $FILENAME)

  if [ ! -z "$EXIST" ]; then

    echo $EXIST
    mysqldump --defaults-extra-file=~/.mysql/mysql.cnf bookstore > $FILENAME

  fi
else
  echo "Missing date argument. Format YYYY-MM-DD"
fi
```

- Make file executable

```bash
chmod +x /usr/local/bin/mysqlrestore
```

- Create a symlink to `/root/bin/mysqlrestore`. The `PATH` is pointing to `/root/bin/` directory

```bash
ln -s /usr/local/bin/mysqlrestore /root/bin/mysqlrestore
```

### Test restore program

- Delete database

```bash
mysql> DROP DATABASE bookstore;
```

- Recreate database

*(You need an empty database to do a restore)*

```bash
mysql> CREATE DATABASE bookstore;
```

- Run the restore script

```bash
mysqlrestore YYYY-MM-DD
```

- Verify that the database is restored

```bash
mysql> USE bookstore;
mysql> SHOW TABLES;
```

## Extra

- Add a backup user and let the user do the backup instead of the root user

- There is a `bs01` comment out in Vagrant, use that machine to make a backup to a remote machine

- Continue with the restore script. Change so that before it does a restore

    1. Check if a database exists, if so delete the database.

    2. Recreate the database with the same name

    3. Do a restore
