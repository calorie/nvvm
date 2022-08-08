require 'simplecov'

SimpleCov.start

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'fileutils'
require 'tmpdir'
require 'nvvm'
require 'nvvm/ext/mkmf'

VERSION1 = 'v0.4.3'.freeze
VERSION2 = 'v0.4.4'.freeze

RSpec.configure do |config|
  config.before :suite do
    cache = cache_dir
    unless File.exist?(cache)
      ENV['NVVMROOT'] = cache
      ENV['NVVMOPT']  = nil
      FileUtils.mkdir_p(cache)
      Nvvm::Installer.fetch
      [VERSION1, VERSION2].each do |v|
        installer = Nvvm::Installer.new(v, [], silent: true)
        installer.checkout
        installer.make_install
      end
      Nvvm::Installer.cp_etc
    end
  end

  config.before :all do
    @tmp = Dir.mktmpdir
    FileUtils.cp_r(cache_dir, @tmp) unless self.class.metadata[:disable_cache]
    ENV['NVVMROOT'] = File.expand_path(File.join(@tmp, '.nvvm_cache'))
    ENV['NVVMOPT']  = nil
  end

  config.after :all do
    FileUtils.rm_rf(@tmp)
  end

  config.before(:all, clean: true) { remove_dirs }
  config.before(:all, repo: true) { cp_repo_dir }
  config.before(:all, src: true) { cp_src_dir }
end

def cache_dir
  File.expand_path(File.join(File.dirname(__FILE__), '..', '.nvvm_cache'))
end

def remove_dirs
  [src_dir, repo_dir, etc_dir].each do |dir|
    FileUtils.rm_rf(dir) if File.exist?(dir)
  end
end

def cp_repo_dir
  return if File.exist?(repo_dir)

  FileUtils.cp_r(File.join(cache_dir, 'repo'), dot_dir)
end

def cp_src_dir
  return if File.exist?(src_dir(@version))

  FileUtils.mkdir_p(src_dir)
  FileUtils.cp_r(File.join(cache_dir, 'src', @version), src_dir)
end
