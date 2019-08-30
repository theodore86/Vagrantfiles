# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'
require_relative 'lib/vagrant-host'
require_relative 'lib/plugins/vagrant-proxy'
require_relative 'lib/plugins/vagrant-hostupdater'
require_relative 'lib/providers/vagrant-vb'


PROJECT_PATH = File.dirname(File.expand_path(__FILE__))
CONFIG = YAML.load_file(File.join(PROJECT_PATH, 'vagrant.yaml'))
HOST = CONFIG[:host]
HOSTSUPDATER = CONFIG[:hostsupdater]
DEFAULT = CONFIG[:defaults]
VAGRANTFILE_API_VERSION = 2 # Vagrantfile API/syntax version.


Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

    #-- Proxy Settings --#
    if Vagrant.has_plugin?("vagrant-proxyconf")
        Proxy.conf(config, HOST)
    end

    #-- HostUpdater Settings --#
    if Vagrant.has_plugin?("vagrant-hostupdater")
        HostUpdater.conf(config, HOSTSUPDATER)
    end

    #-- Guest Settings --#
    config.vm.define HOST[:name] do |node|

        #-- Box Settings --#
        node.vm.box = HOST[:box] ||= DEFAULT[:box]
        node.vm.box_url = HOST[:box_url] ||= DEFAULT[:box_url]
        node.vm.box_check_update = HOST[:update]
        node.vm.hostname = HOST[:name]

        #-- Provider Settings --#
        node.vm.provider "virtualbox" do |vb|
            vb.gui = HOST[:gui]
            vb.name= HOST[:name]
            VirtualBox.resources(vb, HOST)
            VirtualBox.modify_vm(vb, HOST)
            VirtualBox.guest_property(vb, HOST)
        end

        #-- SSH Settings --#
        Host.ssh(config, HOST)

        #-- Networking --#
        Host.networking(node.vm, HOST)

        #-- Shared Folders --#
        Host.synced_folders(node.vm, HOST)

        #-- Shell Provisioners --#
        Host.shell_provision(node.vm, HOST)

        #-- File Provisioners --#
        Host.file_provision(node.vm, HOST)
    end

    config.vm.post_up_message = "#{HOST[:name]} has been successfully deployed:)"

end
