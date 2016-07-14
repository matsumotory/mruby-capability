MRuby::Gem::Specification.new('mruby-capability') do |spec|
  spec.license = 'MIT'
  spec.authors = 'MATSUMOTO Ryosuke'
  spec.version = '0.0.1'

  require 'open3'
  require 'fileutils'

  LIBCAP_VERSION = "2.25"
  LIBCAP_TAG = "libcap-#{LIBCAP_VERSION}"
  LIBCAP_CHECKOUT_URL = "https://kernel.googlesource.com/pub/scm/linux/kernel/git/morgan/libcap.git"
  LIBCAP_DIR = "#{build.build_dir}/libcap-#{LIBCAP_VERSION}"
  LIBCAP_LIBDIR = "#{LIBCAP_DIR}/libcap"
  LIBCAP_LIBFILE = libfile("#{LIBCAP_LIBDIR}/libcap")

  task :clean do
    FileUtils.rm_rf LIBCAP_DIR
  end

  def run_command env, command
    STDOUT.sync = true
    puts "EXEC\t[mruby-capability] #{command}"
    Open3.popen2e(env, command) do |stdin, stdout, thread|
      print stdout.read
      fail "#{command} failed" if thread.value != 0
    end
  end

  file LIBCAP_DIR do
    FileUtils.mkdir_p File.dirname(LIBCAP_DIR)
    run_command ENV, "git clone --depth=1 #{LIBCAP_CHECKOUT_URL} #{LIBCAP_DIR}"
    run_command ENV, "cd #{LIBCAP_DIR} && git fetch origin -q --tags #{LIBCAP_TAG} && git checkout $(git rev-parse #{LIBCAP_TAG})"
  end

  file LIBCAP_LIBFILE => LIBCAP_DIR do
    Dir.chdir(LIBCAP_DIR) do
      e = {
        'CC' => "#{build.cc.command} #{build.cc.flags.join(' ')}",
        'CXX' => "#{build.cxx.command} #{build.cxx.flags.join(' ')}",
        'LD' => "#{build.linker.command} #{build.linker.flags.join(' ')}",
        'AR' => build.archiver.command,
        'prefix' => LIBCAP_LIBDIR,
      }

      run_command e, "make"
    end
  end

  file libfile("#{build.build_dir}/lib/libmruby") => LIBCAP_LIBFILE

  spec.cc.include_paths << "#{LIBCAP_LIBDIR}/include"
  spec.linker.flags_before_libraries << LIBCAP_LIBFILE
end
