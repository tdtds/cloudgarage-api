
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "cloudgarage-api"

Gem::Specification.new do |spec|
  spec.name          = "cloudgarage-api"
  spec.version       = CloudGarage::VERSION
  spec.authors       = ["Tada, Tadashi"]
  spec.email         = ["t@tdtds.jp"]

  spec.summary       = %q{CloudGarage API}
  spec.description   = %q{Control CloudGarage VPS by it's public API}
  spec.homepage      = "https://github.com/tdtds/cloudgarage-api"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rest-client", "~> 2.0"

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "dotenv"
end
