require 'spec_helper'
require 'fileutils'
require 'tmpdir'

describe 'Version' do
  describe 'list' do
    it 'repo_dir not found' do
      allow(File).to receive(:exist?).and_return(false)
      expect(proc { Nvvm::Version.list }).to raise_error SystemExit
    end

    it 'echo available vim versions' do
      expect(Nvvm::Version.list.join("\n")).to match(/\Anightly\nstable\n(v\d\..+(\n){0,1})+\z/)
    end
  end

  describe 'versions' do
    context 'src dirctory exists' do
      it 'echo installed vim versions' do
        expect(Nvvm::Version.versions.join("\n")).to eq "#{VERSION1}\n#{VERSION2}"
      end

      it 'echo installed vim versions without current' do
        Nvvm::Switcher.new(VERSION1).use
        expect(Nvvm::Version.versions.join("\n")).to eq "#{VERSION1}\n#{VERSION2}"
      end
    end
    context 'src dirctory is not found' do
      before do
        @tmp_vvmroot   = ENV['NVVMROOT']
        @tmp2          = Dir.mktmpdir
        ENV['NVVMROOT'] = @tmp2
      end

      after do
        ENV['NVVMROOT'] = @tmp_vvmroot
        FileUtils.rm_rf(@tmp2)
      end

      it 'echo nothing' do
        expect(Nvvm::Version.versions).to eq []
      end
    end
  end

  describe 'latest' do
    it 'return latest vim version' do
      expect(Nvvm::Version.latest).to match(/\Av\d\..+\z/)
    end
  end

  describe 'current' do
    context 'current version is system' do
      before { Nvvm::Switcher.new('system').use }
      it 'return current vim version' do
        expect(Nvvm::Version.current).to eq 'system'
      end
    end

    context 'current version is not system' do
      before { Nvvm::Switcher.new(VERSION1).use }
      it 'return current vim version' do
        expect(Nvvm::Version.current).to eq VERSION1
      end
    end
  end

  describe 'convert' do
    it 'version to tag' do
      expect(Nvvm::Version.convert('0.2.2')).to eq 'v0.2.2'
    end
  end

  describe 'format' do
    context 'tag' do
      it 'return formated vim version' do
        expect(Nvvm::Version.format('v0.2.2')).to eq 'v0.2.2'
      end
    end

    context 'dicimal version' do
      it 'return formated vim version' do
        expect(Nvvm::Version.format('0.2.2')).to eq 'v0.2.2'
      end
    end

    context 'latest' do
      it 'return latest vim version' do
        expect(Nvvm::Version.format('latest')).to match(/\Av\d\..+\z/)
      end
    end
  end
end
