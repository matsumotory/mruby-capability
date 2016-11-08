MRuby::Gem::Specification.new('mruby-capability') do |spec|
  spec.license = 'MIT'
  spec.authors = 'MATSUMOTO Ryosuke'
  spec.version = '0.0.1'

  require 'open3'
  require 'fileutils'

  unless defined?(LIBCAP_VERSION)
    LIBCAP_VERSION = "2.25"
    LIBCAP_TAG = "libcap-#{LIBCAP_VERSION}"
    # tag libcap-2.25 is: https://kernel.googlesource.com/pub/scm/linux/kernel/git/morgan/libcap.git/+/libcap-2.25
    LIBCAP_TARGET_COMMIT = "a0b240a1ead74be7851c98d58cc53c7c244ade58"
    LIBCAP_CHECKOUT_URL = "https://kernel.googlesource.com/pub/scm/linux/kernel/git/morgan/libcap.git"
  end

  def libcap_dir(b); "#{b.build_dir}/libcap-#{LIBCAP_VERSION}"; end
  def libcap_libdir(b); "#{libcap_dir(b)}/libcap"; end
  def libcap_libfile(b); libfile("#{libcap_libdir(b)}/libcap"); end

  task :clean do
    FileUtils.rm_rf libcap_dir(build)
  end

  def run_command env, command
    STDOUT.sync = true
    puts "EXEC\t[mruby-capability] #{command}"
    Open3.popen2e(env, command) do |stdin, stdout, thread|
      print stdout.read
      fail "#{command} failed" if thread.value != 0
    end
  end

  file libcap_dir(build) do
    FileUtils.mkdir_p File.dirname(libcap_dir(build))
    unless File.exist?(libcap_dir(build))
      run_command ENV, "git clone --depth=1 #{LIBCAP_CHECKOUT_URL} #{libcap_dir(build)}"
      run_command ENV, "cd #{libcap_dir(build)} && git fetch origin -q && git checkout -q #{LIBCAP_TARGET_COMMIT}"

      if `uname -r`.include? "2.6.32"
        # CentOS 6 patch
        patch_path = File.expand_path('../misc/fix-centos6-build.patch', __FILE__)
        run_command ENV, "cd #{libcap_dir(build)} && patch -p0 < #{patch_path}"
      end
    end
  end

  file libcap_libfile(build) => libcap_dir(build) do
    Dir.chdir(libcap_dir(build)) do
      e = {
        'CC' => "#{build.cc.command} #{build.cc.flags.join(' ')}",
        'CXX' => "#{build.cxx.command} #{build.cxx.flags.join(' ')}",
        'LD' => "#{build.linker.command} #{build.linker.flags.join(' ')}",
        'AR' => build.archiver.command,
        'prefix' => libcap_libdir(build),
      }

      run_command e, "make"
    end
  end

  file libfile("#{build.build_dir}/lib/libmruby") => libcap_libfile(build)

  spec.cc.include_paths << "#{libcap_libdir(build)}/include"
  spec.linker.flags_before_libraries << libcap_libfile(build)
end
