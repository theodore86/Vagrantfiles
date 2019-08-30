#!/usr/bin/env ruby
# Host settings are derived from the YAML configuration file.
# The module serves only as a namespace for Host operations.

require 'pathname'
require_relative 'utils/common.rb'

module Host
    extend self

    def synced_folders(vm, host)
        if host.key?(:synced_folders)
            folders = host[:synced_folders]
            folders.each do |folder|
                vm.synced_folder folder[:src], folder[:dest], folder[:options]
            end
        end
    end

    def shell_provision(vm, host)
        if host.key?(:provisioners)
            provisioners = host[:provisioners]
            return if !provisioners.key?(:shell)
            shells = provisioners[:shell]
            shells.each do |shell|
                if shell.key?(:options)
                    options = shell[:options]
                    if options.key?(:path)
                        # set absolute path for shell scripts
                        path = File.join(options[:path])
                        if !Pathname.new(path).absolute?
                            path = Common.root_path.join(path).to_s
                        end
                        options[:path] = path
                    end
                end
                vm.provision shell[:name], shell[:options]
            end
        end
    end

    def file_provision(vm, host)
        if host.key?(:provisioners)
            provisioners = host[:provisioners]
            return if !provisioners.key?(:file)
            files = provisioners[:file]
            files.each do |file|
                if file.key?(:options)
                    options = file[:options]
                    if options.key?(:source)
                        src = File.join(options[:source])
                        # set absolute path for source files
                        if !Pathname.new(src).absolute?
                            src = Common.root_path.join(src).to_s
                        end
                        options[:source] = src
                    end
                end
                vm.provision file[:name], file[:options]
            end
        end
    end

    def networking(vm, host)
        if host.key?(:networks)
            nets = host[:networks]
            return if nets.empty?
            nets.each do |net|
                data = net.values[0]
                next if !data.key?(:disabled)
                if !data[:disabled]
                    options = data[:options]
                    options.each { |opts| vm.network data[:type], opts }
                end
            end
        end
    end

    def ssh(config, host)
        if host.key?(:ssh)
            settings = host[:ssh]
            config.ssh.forward_agent = settings[:forward_agent]
            config.ssh.forward_x11 = settings[:forward_x11]
        end
    end

end
