# Overview

Vagrant comes with many great features out of the box to get your environments up and running. Sometimes, however, you want to change the way Vagrant does something or add additional functionality to Vagrant. This can be done via Vagrant *plugins*. Vagrant plugins are written in *Ruby* programming language.

# How to interact?

To interact with the vagrant plugins you need to execute the ``vagrant plugin`` subcommand.

- Install an vagrant plugin:
    - ``vagrant plugin install <plugin name>``
- Uninstall an vagrant plugin:
    - ``vagrant plugin uninstall <plugin name>``
- List all installed vagrant plugins
    - ``vagrant plugin list``

More information regarding the plugin subcommand:

```console
$ vagrant plugin --help
Usage: vagrant plugin <command> [<args>]

Available subcommands:
     expunge
     install
     license
     list
     repair
     uninstall
     update
```

# Where are installed?

- Lists all installed plugins
    - ``%USERPROFILE%\.vagrant.d\plugins.json``
- Actual source code
    - ``%USERPROFILE%\.vagrant.d\gems\gems\"plugin_name-version"``
- Ryby packages
    - ``%USERPROFILE%\.vagrant.d\gems\specifications\"plugin_name-version".gemspec``

# Automatic plugin installation

There’s an [intentionally undocumented feature](https://github.com/mitchellh/vagrant/issues/5035) of Vagrant introduced in v1.7 which gives us a solution:<br>

Vagrant will execute the contents of a ``.vagrantplugins`` file before attempting to execute the Vagrantfile. Having the following snippet (updating the ``REQUIRED_PLUGINS`` hash accordingly) and then a vagrant up will be all you need:

```ruby
REQUIRED_PLUGINS = {
    'vagrant-vbguest' => '>= 0.17.1',
    'sahara' => '>= 0.0.17',
    'vagrant-proxyconf' => '>= 1.5.2',
    'vagrant-host-shell' => '>= 0.0.4',
    'vagrant-hostsupdater' => '>= 1.1.1.160'
}


needs_restart = false

plugins = `vagrant plugin list`.scan(/^[\w-]+?(?=\s\()/)
plugins.each do |name|
    unless REQUIRED_PLUGINS.key? name
    system "vagrant plugin uninstall #{name}"
    needs_restart = true
    end
end

REQUIRED_PLUGINS.each do |name, version|
    unless Vagrant.has_plugin? name, version
        if system "vagrant plugin install #{name} --plugin-version \"#{version}\""
            needs_restart = true
        else
            abort "Installation of #{name} plugin has failed. Aborting"
        end
    end
end

if needs_restart
    exec "vagrant #{ARGV.join' '}"
end
```

# Notable Plugins

- [List of available Vagrant plugins from GitHub wiki.](https://github.com/hashicorp/vagrant/wiki/Available-Vagrant-Plugins)
- [vagrant-vbguest](https://github.com/dotless-de/vagrant-vbguest) - autoupdate VirtualBox guest additions (according to VB version).
- [vagrant-hostsupdater](https://github.com/cogitatio/vagrant-hostsupdater) - adds an entry to your /etc/hosts file on the host system.
- [sahara](https://github.com/jedi4ever/sahara) - easy manage VM state (commit/rollback while experimenting with software stack).
- [vagrant-host-shell](https://github.com/phinze/vagrant-host-shell) - a vagrant provisioner to run commands on the host when a VM boots.
- [vagrant-proxyconf](https://github.com/tmatilai/vagrant-proxyconf) - plugin that configures the virtual machine to use specified proxies.
