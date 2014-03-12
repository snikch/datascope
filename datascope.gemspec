# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |gem|
  gem.name          = "datascope"
  gem.version       = "0.0.6"
  gem.authors       = ["Will Leinweber"]
  gem.email         = []
  gem.description   = %q{postgres 9.2 visibility}
  gem.summary       = %q{postgres 9.2 visibility}
  gem.homepage      = "https://github.com/will/datascope"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(spec)/})
  gem.require_paths = ["lib"]

  ##
  # Runtime dependencies.

  gem.add_runtime_dependency "sinatra"
  gem.add_runtime_dependency "puma"
  gem.add_runtime_dependency "pg"
  gem.add_runtime_dependency "sequel"
  gem.add_runtime_dependency "sequel_pg"
  gem.add_runtime_dependency "haml"
  gem.add_runtime_dependency "rack-coffee"
end

