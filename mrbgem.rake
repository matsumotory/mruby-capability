MRuby::Gem::Specification.new('mruby-capability') do |spec|
  spec.license = 'MIT'
  spec.authors = 'MATSUMOTO Ryosuke'
  spec.version = '0.0.1'
  spec.linker.libraries << 'cap'
end
