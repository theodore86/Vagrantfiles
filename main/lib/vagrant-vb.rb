#!/usr/bin/env ruby
# Virtualbox customization through host yaml configuration file.
# The VirtualBox module serves as a namespace for varius operations.

require_relative 'utils/sys.rb'

module VirtualBox
    extend self

    def modify_vm(provider, host)
        if host.key?(:customize)
            commands = host[:customize]
            commands.each do |command|
                name = command.fetch(:command, nil)
                if name == 'modifyvm'
                    settings = command.fetch(:settings, nil)
                    return if !settings
                    settings.each { |s| provider.customize [name, :id] + s }
                end
            end
        end
    end

    def guest_property(provider, host)
        if host.key?(:customize)
            commands = host[:customize]
            commands.each do |command|
                name = command.fetch(:command, nil)
                if name == 'guestproperty'
                    actions = command.fetch(:actions, nil)
                    return if !actions
                    actions.each do |action|
                        action.each { |a, s| provider.customize [name, a.to_s, :id] + s }
                    end
                end
            end
        end
    end

    #https://github.com/rdsubhas/vagrant-faster
    #1/4th of memory, if you have more than 2GB RAM
    #1/2 of the available CPU cores, if you have more than 1 CPU
    #or will simply leave the machine defaults as it is
    def resources(provider, host)
        cpus = host.key?(:cpus) ? host[:cpus] : nil
        memory = host.key?(:memory) ? host[:memory] : nil
        if !cpus
            cpus = Sys.cpus
            if cpus > 1
                cpus = cpus / 2
            end
        end
        if !memory
            memory = Sys.memory
            if memory > 2048
                memory = memory / 4
            end
        end
        begin
            if (cpus > 0 && memory > 0)
                provider.cpus = cpus
                provider.memory = memory
            end
        rescue
        end
    end

end
