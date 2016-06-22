MRuby::Build.new do |conf|
  toolchain :gcc
  conf.gembox 'default'
  conf.gem File.expand_path(File.dirname(__FILE__))
  conf.enable_test

  conf.cc do |cc|
    cc.flags = << "-Wno-error=declaration-after-statement"
  end
end
