require 'fileutils'

module Nvvm
  class Installer
    def initialize(version, conf, silent = false)
      nvvmopt  = ENV['NVVMOPT']
      @silent  = silent ? '> /dev/null 2>&1' : ''
      @version = version
      @conf    = conf.flatten.empty? && nvvmopt ? nvvmopt.split(' ') : conf
    end

    def self.fetch
      system("git clone --quiet #{VIM_URI} #{repo_dir}") unless File.exist?(repo_dir)
    end

    def self.pull
      fetch unless File.exist?(repo_dir)
      Dir.chdir(repo_dir) do
        system('git pull --rebase --quiet')
      end
    end

    def checkout
      src = src_dir(@version)
      return if File.exist?(src)
      FileUtils.mkdir_p(src)
      archive = "git archive --format=tar #{@version}"
      expand  = "(cd #{src} && tar xf -)"
      Dir.chdir repo_dir do
        system("#{archive} | #{expand} #{@silent}")
      end
    end

    def make_clean
      src       = src_dir(@version)
      src_build = File.join(src, 'build')
      FileUtils.rm_rf(src_build) if File.exist?(src_build)
      Dir.chdir src do
        system("make clean #{@silent}")
      end
    end

    def make_install
      src = src_dir(@version)
      Dir.chdir src do
        system("make CMAKE_BUILD_TYPE=Release #{@silent}")
      end
    end

    def self.cp_etc
      current_login = login_file
      path          = File.join(File.dirname(__FILE__), '..', '..', 'etc', 'login')
      login         = File.expand_path(path)
      if !File.exist?(current_login)
        etc = etc_dir
        FileUtils.mkdir_p(etc)
        FileUtils.cp(login, etc)
      elsif !FileUtils.compare_file(login, current_login)
        FileUtils.cp(login, etc_dir)
      end
    end

    def message
      return if !$?.success? || !@silent.empty?
      print "\e[32m"
      puts <<-MESSAGE

  Neovim is successfully installed. For daily use,
  please add the following line into your ~/.bash_login etc:

  test -f ~/.nvvm/etc/login && source ~/.nvvm/etc/login

      MESSAGE
      print "\e[0m"
    end
  end
end
