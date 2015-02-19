# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "dtvcontroller/version"

Gem::Specification.new do |spec|
  spec.name          = "dtvcontroller"
  spec.version       = Dtvcontroller::VERSION
  spec.authors       = ["Nicholas M. Petty"]
  spec.email         = ["nick@ihackeverything.com"]
  spec.description   = "Allows control of DirecTV Set Top Boxes whoms Whole-Home -> External Device settings are set to Allow"
  spec.summary       = "DirecTV STB Controller"
  spec.homepage      = "http://github.com/nickpetty/dtvcontroller-gem"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "pry"
end
