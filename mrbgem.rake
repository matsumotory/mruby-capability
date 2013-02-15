MRuby::Gem::Specification.new('mruby-capability') do |spec|
  spec.license = 'MIT'
  spec.authors = 'MATSUMOTO Ryosuke'
  spec.linker.libraries << 'cap'
end
