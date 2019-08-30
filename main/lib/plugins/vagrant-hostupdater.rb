#!/usr/bin/env ruby
# Module to add entries to your /etc/hosts on the host system.
# https://github.com/cogitatio/vagrant-hostsupdater.
# The module servers only as a namespace for host-updater plugin operations.

module HostUpdater
    extend self

    @@config = nil

    def conf(config, updater)
        set_config(config)
        update(updater)
    end

    def set_config(value)
        @@config = value
    end

    def config
        @@config
    end

    private

        def update(updater)
            config.hostupdater.aliases = updater[:aliases]
            config.hostupdater.remove_on_suspend = updater[:remove_on_suspend]
        end
end
