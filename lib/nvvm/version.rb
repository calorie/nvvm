module Nvvm
  class Version
    def self.list
      abort "#{repo_dir} not found." unless File.exist?(repo_dir)
      Dir.chdir(repo_dir) do
        return `git tag`.split
      end
    end

    def self.versions
      output = []
      src    = src_dir
      return output unless File.exist?(src)
      Dir.glob(File.join(src, '*')).sort.each do |d|
        output << File.basename(d)
      end
      output
    end

    def self.latest
      list.select { |v| v =~ /\Av\d\..+\z/ }.last
    end

    def self.current
      d = current_dir
      File.exist?(d) ? File.basename(File.readlink(d)) : 'system'
    end

    def self.convert(version)
      "v#{version}"
    end

    def self.format(version)
      case version
      when /\Alatest\z/
        version = latest
      when /\A(\d\.\d(a|b){0,1}(\.\d+){0,1})\z/
        version = convert(version)
      end
      version
    end
  end
end
