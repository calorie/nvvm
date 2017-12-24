require 'spec_helper'

describe 'Uninstaller' do
  describe 'uninstall' do
    context 'Neovim version is currently used' do
      before :all do
        version = VERSION1
        Nvvm::Switcher.new(version).use
        @uninstaller = Nvvm::Uninstaller.new(version)
      end

      after :all do
        Nvvm::Switcher.new('system').use
      end

      it 'raise error' do
        expect(proc { @uninstaller.uninstall }).to raise_error SystemExit
      end
    end

    context 'can uninstall version' do
      before :all do
        @version = VERSION1
        Nvvm::Switcher.new('system').use
        Nvvm::Uninstaller.new(@version).uninstall
      end

      it 'delete src dir' do
        expect(File.exist?(src_dir(@version))).not_to be_truthy
      end

      it 'delete vims dir' do
        expect(File.exist?(vims_dir(@version))).not_to be_truthy
      end
    end
  end
end
