#!/usr/bin/env ruby
#Module with Host OS level functions

module Sys
    extend self

    HOST = RbConfig::CONFIG['host_os']

    def cpus()

        cpus = -1
        begin
            if HOST =~ /darwin/
                cpus = `sysctl -n hw.ncpu`.to_i
            elsif HOST =~ /linux/
                cpus = `nproc`.to_i
            elsif HOST =~ /mswin|mingw|cygwin/
                cpus = `wmic cpu Get NumberOfCores`.split[1].to_i
            end
        rescue
        end
        return cpus
    end

    def memory()

        mem = -1
        begin
            if HOST =~ /darwin/
                mem = `sysctl -n hw.memsize`.to_i / 1024 / 1024
            elsif HOST =~ /linux/
                mem = `grep 'MemTotal.*kB' /proc/meminfo | grep -Eo '[0-9]+'`.to_i / 1024
            elsif HOST =~ /mswin|mingw|cygwin/
                mem = `wmic computersystem Get TotalPhysicalMemory`.split[1].to_i / 1024 / 1024
            end
        rescue
        end
        return mem
    end

end
