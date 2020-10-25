require 'fileutils'

module Nvvm
  class Uninstaller
    def initialize(version)
      @version = version
    end

    def uninstall
      abort "#{@version} can not be uninstalled; It is currently used." if used?
      src = src_dir(@version)
      FileUtils.rm_rf(src) if File.exist?(src)
    end

    private

    def used?
      current = current_dir
      return false unless File.exist?(current)

      File.readlink(current) == src_dir(@version)
    end
  end
end
