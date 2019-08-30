# Overview

**VirtualBox is the default provider** for Vagrant. VirtualBox is still the most accessible platform to use Vagrant: it is free, cross-platform, and has been supported by Vagrant for years. With VirtualBox as the default provider, it provides the lowest friction for new users to get started with Vagrant.

# Boxes

A *box* is the base image used to create a virtual environment with Vagrant. It is meant to be a portable file which can be used by others on any platform that Vagrant runs in order to bring up a running virtual environment. The ``vagrant box`` utility provides all the power for managing boxes, and ``vagrant package`` is used to create boxes.

The easiest way to use a box is to add a box from the [publicly available catalog of Vagrant boxes](https://app.vagrantup.com/boxes/search). You can also add and share your own customized boxes on this website.

Boxes also support versioning so that members of your team using Vagrant can update the underlying box easily, and the people who create boxes can push fixes and communicate these fixes efficiently.

Most popular are the [Bento boxes](https://vagrantcloud.com/bento). The Bento boxes are open source and built for a number of providers including VMware, Virtualbox, and Parallels. There are a variety of operating systems and versions available.

In order to update the base box you need to set to ``true`` the value of the ``update`` key. Moreover, if you want to update completely the base box you need to change the values of ``:box:`` and ``:box_url:``.

```yaml
:host:
    :update: false
    :box: 'bento/ubuntu-18.04'
    :box_url: 'https://vagrantcloud.com/bento/ubuntu-18.04'
```

# Resources

Virtual machine (Guest) resources can be adapted based on the host machine resources.

By default, ``:cpus:`` and ``:memory:`` values are set to ``null``.

In such case the guest machine resouces will be:

- **1/2** of the available host machine CPU cores, if you have more than 1 CPU core.
- **1/4th** of memory, if you have more than 2GB RAM.
- or will simply leave the guest machine defaults as it is.

```yaml
:host:
    :cpus: null
    :memory: null
```

# Customizations

[VBoxManage](https://www.virtualbox.org/manual/ch08.html) is a utility that can be used to make modifications to VirtualBox virtual machines from the command line.Vagrant exposes a way to call any command against VBoxManage just prior to booting the machine. Currently the only supported VBoxManage subcommands are: *modifyvm* and *guestproperty* but this functionality can be easily programmatically extended to support more subcommands if necessary.

```yaml
    :customize:
        - :command: 'modifyvm'
          :settings:
              # see https://github.com/mitchellh/vagrant/issues/1807
              - ['--natdnshostresolver1', 'on']
              - ['--natdnsproxy1', 'on']
              - ['--nictype1', 'virtio']
        # https://gist.github.com/aboutte/f4adcbfc33cc7309791e0d21102c3d38
        - :command: 'guestproperty'
          :actions:
              - :set: ['/VirtualBox/GuestAdd/VBoxService/--timesync-interval', 10000]
              - :set: ['/VirtualBox/GuestAdd/VBoxService/--timesync-min-adjust', 100]
              - :set: ['/VirtualBox/GuestAdd/VBoxService/--timesync-set-on-restore', 1]
              - :set: ['/VirtualBox/GuestAdd/VBoxService/--timesync-set-start', 1]
              - :set: ['/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold', 1000]
```
