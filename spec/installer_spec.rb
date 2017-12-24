require 'spec_helper'
require 'mkmf'

describe 'Installer', disable_cache: true do
  before :all do
    @version   = VERSION1
    @installer = Nvvm::Installer.new(@version, [], true)
  end

  let(:version_src_dir) { src_dir(@version) }
  let(:nvim) { File.join(version_src_dir, 'build', 'bin', 'nvim') }

  describe 'install' do
    context 'fetch', clean: true do
      before(:all) { Nvvm::Installer.fetch }

      it 'exists repo dir' do
        expect(File.exist?(repo_dir)).to be_truthy
      end

      it 'success to clone' do
        expect($?.success?).to be_truthy
      end

      it 'exists Makefile file' do
        expect(File.exist?(File.join(repo_dir, 'Makefile'))).to be_truthy
      end
    end

    context 'pull', clean: true, repo: true do
      before :all do
        Dir.chdir(repo_dir) do
          system('git reset --hard HEAD')
          system('git clean -fdx')
        end
      end

      it 'repo_dir not found' do
        allow(File).to receive(:exist?).with(repo_dir).and_return(false)
        allow(Nvvm::Installer).to receive(:fetch).and_return(true)
        expect(Nvvm::Installer).to receive(:fetch)
        Nvvm::Installer.pull
      end

      it 'success to pull' do
        expect($?.success?).to be_truthy
      end

      it 'Neovim is up-to-date' do
        Dir.chdir(repo_dir) do
          expect(`export LANG=en_US.UTF-8;git pull`).to match(/Already up-to-date./)
        end
      end
    end

    context 'checkout', clean: true, repo: true do
      before :all do
        @installer.checkout
      end

      it 'exists src dir' do
        expect(File.exist?(version_src_dir)).to be_truthy
      end

      it 'exists configure file' do
        configure = File.join(version_src_dir, 'configure')
        expect(File.exist?(configure)).to be_truthy
      end
    end

    context 'make_install', clean: true, repo: true, src: true do
      before :all do
        @installer.make_install
      end

      it 'can execute nvim' do
        expect(system("#{nvim} --version > /dev/null 2>&1")).to be_truthy
      end
    end

    context 'cp_etc', clean: true do
      context 'login file not exist' do
        before(:all) { Nvvm::Installer.cp_etc }

        it 'exists etc dir' do
          expect(File.exist?(etc_dir)).to be_truthy
        end

        it 'exists login file' do
          expect(File.exist?(login_file)).to be_truthy
        end
      end

      context 'login file exists and it is not latest' do
        before do
          allow(FileUtils).to receive(:compare_file).and_return(false)
        end

        it 'exists login file' do
          path  = File.join(File.dirname(__FILE__), '..', 'etc', 'login')
          login = File.expand_path(path)
          expect(FileUtils).to receive(:cp).with(login, etc_dir)
          Nvvm::Installer.cp_etc
        end
      end
    end
  end

  describe 'rebuild' do
    context 'make_clean', clean: true, src: true do
      before :all do
        @installer.make_clean
      end

      it 'not exists build dir' do
        path = File.join(version_src_dir, 'build')
        expect(File.exist?(path)).not_to be_truthy
      end
    end
  end

  describe 'message' do
    before { system('') }

    it 'command failed' do
      allow($?).to receive(:success?).and_return(false)
      expect { @installer.message }.to_not output(/success/).to_stdout
    end

    it 'silent' do
      allow($?).to receive(:success?).and_return(true)
      expect { @installer.message }.to_not output(/success/).to_stdout
    end

    it 'success' do
      allow($?).to receive(:success?).and_return(true)
      installer = Nvvm::Installer.new(@version, [])
      expect { installer.message }.to output(/success/).to_stdout
    end
  end
end
