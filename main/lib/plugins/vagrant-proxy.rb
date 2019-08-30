#!/usr/bin/env ruby
# Module for Vagrant proxy configuration settings.
# https://github.com/tmatilai/vagrant-proxyconf.
# The module servers only as a namespace for proxy plugin operations.

module Proxy
    extend self

    @@http_url = ""
    @@https_url = ""
    @@config = nil

    def conf(config, host)
        if host.key?(:proxy)
            proxy = host[:proxy]
            set_config(config)
            set_http_url(proxy)
            set_https_url(proxy)
            system_wide(proxy)
            applications(proxy)
        end
    end

    def set_config(value)
        @@config = value
    end

    def config
        @@config
    end

    def set_http_url(value)
        url = 'http://'
        http = value[:http]
        if http.key?(:auth)
            token = "#{http[:user]}:#{http[:pass]}@"
            url = "#{url}#{token}"
        end
        @@http_url = "#{url}#{http[:address]}:#{http[:port]}"
    end

    def http_url
        @@http_url
    end

    def set_https_url(value)
        https = value[:https]
        url_s = https[:is_supported] ? 'https://' : 'http://'
        if https.key?(:auth)
            token = "#{https[:user]}:#{https[:pass]}@"
            url_s = "#{url_s}#{token}"
        end
        @@https_url = "#{url_s}#{https[:address]}:#{https[:port]}"
    end

    def https_url
        @@https_url
    end

    private

        def system_wide(proxy)
            sys = proxy[:system]
            config.proxy.enabled = sys[:enabled]
            if sys[:enabled]
                config.proxy.no_proxy = sys[:no_proxy]
                config.proxy.http = http_url
                config.proxy.https = https_url
            end
        end

        def applications(proxy)
            sys = proxy[:system]
            applications = sys[:applications]
            config.proxy.enabled = applications
            applications.keys.each do |application|
                eval "config.#{application}_proxy.http = http_url"
                eval "config.#{application}_proxy.https = https_url"
            end
        end

end
