#!/usr/bin/env ruby
#Module with Common functions

require 'pathname'

module Common
    extend self

    # Project root path
    def root_path()
        root_path = PROJECT_PATH if defined?(PROJECT_PATH)
        root_path ||= Dir.pwd
        return Pathname.new(root_path).expand_path
    end
end
