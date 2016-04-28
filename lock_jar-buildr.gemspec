# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lock_jar/buildr/version'

Gem::Specification.new do |spec|
  spec.name          = "lock_jar-buildr"
  spec.version       = LockJar::Buildr::VERSION
  spec.authors       = ["Michael Guymon"]
  spec.email         = ["michael@tobedevoured.com"]

  spec.summary       = 'LockJar support for Buildr'
  spec.description   = 'LockJar support for Buildr'
  spec.homepage      = 'http://github.com/mguymon/lock_jar-buildr'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "lock_jar", "> 0.15.0", "< 1"
  spec.add_runtime_dependency "buildr", "> 1.4"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop", "~> 0.39"
  spec.add_development_dependency "pry"
end
