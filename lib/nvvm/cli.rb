require 'thor'

module Nvvm
  class Cli < Thor
    include Thor::Actions
    include Validator

    desc 'install [VERSION]', 'Install a specific version of Neovim'
    method_option :use, type: :boolean, aliases: '-u', banner: 'Use installed Neovim'
    def install(version, *conf)
      installer = Installer.new(Version.format(version), conf)
      installer.checkout
      installer.make_install
      Installer.cp_etc
      invoke :use, [version], {} if options[:use]
      installer.message
    end

    desc 'update', 'Update to latest version of Neovim'
    def update
      Installer.pull
      if (current = Version.current) == 'system'
        run 'nvvm install --use latest'
        run 'nvvm use system' unless $?.success?
      else
        run 'nvvm use system'
        run 'nvvm install --use latest'
        action = $?.success? ? 'uninstall' : 'use'
        run "nvvm #{action} #{current}"
      end
    end

    desc 'reinstall [VERSION]', 'Reinstall a specific version'
    def reinstall(version, *conf)
      invoke :uninstall, [version]
      invoke :install, [version, *conf]
    end

    desc 'rebuild [VERSION]', 'Rebuild a specific version of Neovim'
    def rebuild(version, *conf)
      installer = Installer.new(Version.format(version), conf)
      installer.make_clean
      installer.make_install
    end

    desc 'use [VERSION]', 'Use a specific version of Noevim as the default one.'
    def use(version)
      Switcher.new(Version.format(version)).use
    end

    desc 'list', 'Look available versions of Neovim.'
    def list
      Installer.pull
      puts Version.list.join("\n")
    end

    desc 'versions', 'Look installed versions of Neovim.'
    def versions
      puts Version.versions.join("\n")
    end

    desc 'uninstall [VERSION]', 'Uninstall a specific version of Neovim.'
    def uninstall(version)
      Uninstaller.new(Version.format(version)).uninstall
    end

    no_commands do
      def invoke_command(command, *args)
        validate_before_invoke(command.name)
        super
      end
    end
  end
end
