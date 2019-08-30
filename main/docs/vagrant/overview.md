This quote comes straight from the [Vagrant website](https://www.vagrantup.com/):

---

*Vagrant is a tool for building and managing virtual machine environments in a single workflow. With an easy-to-use workflow and focus on automation, Vagrant lowers development environment setup time, increases production parity, and makes the “works on my machine” excuse a relic of the past*.

---

Vagrant makes it easy to create reproducible virtualised environments. Machines are provisioned on top of VirtualBox, VMWare, AWS, or any other provider. Vagrant includes support for configuration management tools like Chef or Ansible. Naturally you can use simple shell scripts to automatically install and configure software as well. All of this is defined in a [Vagrantfile](../vagrantfile/#Introduction).

The [Vagrantfile](../vagrantfile/#Introduction) defines the *box*, VM customizations (like memory and networking settings), and which provisioners to run. The *box* is a base image. This may be a VirtualBox image or an AMI (Amazon Machine Image) on AWS. Essentially, this is where you decide the operating system. Then, you use the various provisioners to set everything up. Once you have everything in the Vagrantfile, you’re ready to go.

Now anyone can **recreate the same test environment** with a few short commands!
