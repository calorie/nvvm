Gem::Specification.new do |s|
  s.name = "nvvm".freeze
  s.version = "0.5.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Yu Shigetani".freeze]
  s.date = "2022-08-08"
  s.description = "Neovim version manager.".freeze
  s.email = "s2g4t1n2@gmail.com".freeze
  s.executables = ["nvvm".freeze]
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.md"
  ]
  s.files = [
    ".document",
    ".rspec",
    ".rubocop.yml",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.md",
    "Rakefile",
    "VERSION",
    "bin/nvvm",
    "etc/login",
    "lib/nvvm.rb",
    "lib/nvvm/accessor.rb",
    "lib/nvvm/cli.rb",
    "lib/nvvm/constants.rb",
    "lib/nvvm/ext/mkmf.rb",
    "lib/nvvm/installer.rb",
    "lib/nvvm/switcher.rb",
    "lib/nvvm/uninstaller.rb",
    "lib/nvvm/validator.rb",
    "lib/nvvm/version.rb",
    "nvvm.gemspec",
    "spec/accessor_spec.rb",
    "spec/installer_spec.rb",
    "spec/spec_helper.rb",
    "spec/switcher_spec.rb",
    "spec/uninstaller_spec.rb",
    "spec/validator_spec.rb",
    "spec/version_spec.rb"
  ]
  s.homepage = "http://github.com/calorie/nvvm".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = '>= 1.9'
  s.rubygems_version = "3.3.19".freeze
  s.summary = "Neovim version manager".freeze

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<thor>.freeze, ["~> 1.2.1"])
    s.add_development_dependency(%q<rdoc>.freeze, ["~> 6.4.0"])
    s.add_development_dependency(%q<rspec>.freeze, ["~> 3.11.0"])
    s.add_development_dependency(%q<rubocop>.freeze, ["~> 1.33.0"])
  else
    s.add_dependency(%q<thor>.freeze, ["~> 1.2.1"])
    s.add_dependency(%q<rdoc>.freeze, ["~> 6.4.0"])
    s.add_dependency(%q<rspec>.freeze, ["~> 3.11.0"])
    s.add_dependency(%q<rubocop>.freeze, ["~> 1.33.0"])
  end
end

