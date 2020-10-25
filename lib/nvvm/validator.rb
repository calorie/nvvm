require 'mkmf'

module Nvvm
  module Validator
    METHOD_MAP = {
      install:   %w[version? git? new_version?],
      update:    %w[git?],
      reinstall: %w[git? installed_version?],
      rebuild:   %w[version? git? installed_version?],
      use:       %w[version? installed_version?],
      list:      %w[git?],
      uninstall: %w[version? installed_version?]
    }.freeze

    module_function

    def validate_before_invoke(command)
      return unless validations = METHOD_MAP[command.to_sym]
      validations.each { |v| send(v) }
    end

    def git?
      abort 'git is required to install.' unless find_executable('git')
      true
    end

    def version?
      abort 'undefined Neovim version. please run [ nvvm list ].' if find_version.nil?
      true
    end

    def new_version?(ver = nil)
      Installer.pull
      ver = version if ver.nil?
      abort "#{ver} is already installed." if version_include?(ver)
      true
    end

    def installed_version?(ver = version)
      abort "#{ver} is not installed." unless version_include?(ver)
      true
    end

    private

    def find_version
      version_regex = /\Av\d\..+\z|\A(\d\.\d(a|b){0,1}(\.\d+){0,1})\z/
      regex         = /(\Asystem\z|\Alatest\z|\Anightly\z|#{version_regex})/
      $*.find { |v| v =~ regex }
    end

    def version
      Version.format(find_version)
    end

    def version_include?(ver)
      Version.versions.include?(ver) || use_system?(ver)
    end

    def use_system?(ver)
      ver == 'system' && $*.include?('use')
    end
  end
end
