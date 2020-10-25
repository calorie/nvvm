require 'fileutils'

module Nvvm
  class Switcher
    def initialize(version)
      @version = version
    end

    def use
      current = current_dir
      FileUtils.rm(current) if File.exist?(current)
      return if @version == 'system'

      src = src_dir(@version)
      abort "#{@version} is not installed." unless File.exist?(src)
      FileUtils.ln_s(src, current)
    end
  end
end
