# Lab - Vagrant

## Description

Vagrant is one of many automation tools and is one of the popular ones in the market. VMs will be provisioned with Vagrant for the labs.

## Prerequisites

[Vagrant](https://www.vagrantup.com/downloads)
[Virtualbox](https://www.virtualbox.org/wiki/Downloads)

## Objectives

Try out Vagrant commands
Deploy two VM with Vagrant

## Software

Vagrant

## Vagrant

Creates two VM:
`server01 172.22.100.10`
`client01 172.22.100.20`

## TODO

### Run Vagrantfile to setup two VM

- Run Vagrantfile to kick-off two machines VirtualBox

- Use vagrant ssh to connect to your `client01`

- Ping `server01`

- Exit from your VM and see the status of your vagrant machine

- Stop the `client01`

- Verify that the machine has stopped

- Stop the `server01`

- Verify that the machine has stopped

- Use vagrant to delete your both your machines

- Verify that the machines have been deleted


## Commands (hints)

```bash
vagrant up
vagrant ssh
vagrant halt
vagrant destroy
vagrant status
vagrant help # The help command is very helpful and easy to understand
```

## Answers

### Run Vagrantfile to setup two VM

- Run Vagrantfile to kick-off two machines VirtualBox

```bash
vagrant up
```

- Use vagrant ssh to connect to your `client01`

```bash
vagrant ssh client01
```

- Ping `server01`

```bash
ping -c3 172.22.100.10
```

- Exit from your VM and see the status of your vagrant machine

```bash
vagrant status
```

- Stop the `client01`

```bash
vagrant halt client01
```

- Verify that the machine has stopped

```bash
vagrant status
```

- Stop the `server01`

```bash
vagrant halt server01
```

- Verify that the machine has stopped

```bash
vagrant status
```

- Use vagrant to delete your both your machines

```bash
vagrant destroy
```

- Verify that the machines have been deleted

```bash
vagrant status
```

## Extra

- Play around with vagrant commands. Use `vagrant help`

## Links

[Vagrant homepage](https://www.vagrantup.com/)
