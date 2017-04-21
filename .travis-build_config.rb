MRuby::Build.new do |conf|
  toolchain :gcc
  conf.gembox 'default'
  conf.gem File.expand_path(File.dirname(__FILE__))
  if ENV['MRB_CAPABILITY_ENABLE_AMBIENT']
    conf.cc.defines << 'MRB_CAPABILITY_ENABLE_AMBIENT'
  end
  conf.enable_test
end
