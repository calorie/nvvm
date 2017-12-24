module Nvvm
  module Accessor
    module_function

    def dot_dir
      File.expand_path(ENV['NVVMROOT'] || '~/.nvvm')
    end

    def etc_dir
      File.join(dot_dir, 'etc')
    end

    def repo_dir
      File.join(dot_dir, 'repo')
    end

    def src_dir(version = '')
      File.join(dot_dir, 'src', version)
    end

    def login_file
      File.join(etc_dir, 'login')
    end

    def current_dir
      File.join(src_dir, 'current')
    end
  end
end
