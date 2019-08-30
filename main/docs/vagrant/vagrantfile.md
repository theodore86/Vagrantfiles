# Introduction

The **Vagrantfile** is a Ruby file used to configure **Vagrant** on a per project basis. The main function of the **Vagrantfile** is to described the virtual machines required for a project as well as how to configure and provision theses machines.

![Vagrantfile](../img/vagrantfile.png "Vagrantfile")

# Load Order

An important concept to understand is how Vagrant loads the Vagrantfile. Actually, there are a series of Vagrantfiles that Vagrant will load. Each subsequent Vagrant loaded will overriden any settings set previously. The Vagrantfiles that are loaded and the order they're loaded is shown below:

1. Vagrantfile from the gem directory is loaded. This contains all the defaults and should never be edited.
2. Vagrantfile from the box directory is loaded if a box is specified. This is the Vagrantfile that is packaged with the box if you use the ``--vagrantfile`` option when packaging.
3. Vagrantfile from the hole directory (defaults to ``~/.vagrant.d/``) is loaded if it exists. This Vagrantfile allows you to set some defaults that may be specific to your user.
4. Vagrantfile from the project directory is loaded. This is typically the file that users will be touching.

Therefore, the Vagrantfile in the project directory overwritten any conflicting configuration from the home directory which overwrites any conflicting configuration from a box which overwrites any conflicting configuration from the default file.

# Options

There are many options available to configure Vagrant. The options include specifying the box to use, shared folders, networking configuration etc.

The most important configuration options are listed below:

- ``config.vm.box``
- ``config.vm.box_url``
- ``config.vm.customize``
- ``config.vm.define``
- ``config.vm.forward_port``
- ``config.vm.guest``
- ``config.vm.hostname``
- ``config.vm.network``
- ``config.vm.provision``
- ``config.vm.share_folder``
- ``config.ssh.host``
- ``config.ssh.port``
- ``config.ssh.username``
- ``config.ssh.forward_x11``
- ``config.ssh.shell``
- ``config.ssh.max_retries``
- ``config.ssh.timeout``
- ``config.package.name``
- ``config.vagrant.host``
- ``config.vagrant.dotfile_name``
