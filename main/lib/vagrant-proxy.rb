#!/usr/bin/env ruby
# Module for Vagrant proxy configuration settings.
# https://github.com/tmatilai/vagrant-proxyconf.
# The module servers only as a namespace for proxy plugin operations.

module Proxy
    extend self

    def conf(config, proxy)
    url = 'http://'
    url_s = 'https://'
    http = proxy[:http]
    if http.key?(:auth)
        token = "#{http[:user]}:#{http[:pass]}@"
            url = "#{url}#{token}"
        end
    https = proxy[:https]
    if https.key?(:auth)
            token = "#{https[:user]}:#{https[:pass]}@"
        url_s = "#{url_s}#{token}"
    end
    url = "#{url}#{http[:address]}:#{http[:port]}"
    url_s = "#{url_s}#{https[:address]}:#{https[:port]}"
    config.proxy.http = url
    config.proxy.https = url_s
    config.proxy.enabled = proxy[:enabled]
    config.proxy.no_proxy = proxy[:no_proxy]
    end
end
