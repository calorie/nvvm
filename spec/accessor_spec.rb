require 'spec_helper'

describe 'Accessor' do
  it 'can access nvvm home directory' do
    expect(File.exist?(dot_dir)).to be_truthy
  end

  it 'can access etc directory' do
    expect(File.exist?(etc_dir)).to be_truthy
  end

  it 'can access repo directory' do
    expect(File.exist?(repo_dir)).to be_truthy
  end

  it 'can access src directory' do
    expect(File.exist?(src_dir)).to be_truthy
  end

  it 'can access login file' do
    expect(File.exist?(login_file)).to be_truthy
  end

  context 'of current directory' do
    before { Nvvm::Switcher.new(VERSION1).use }
    after { Nvvm::Switcher.new('system').use }

    it 'can access current directory' do
      expect(File.exist?(current_dir)).to be_truthy
    end
  end
end
