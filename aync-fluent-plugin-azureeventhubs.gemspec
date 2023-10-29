# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.authors       = ["Sandeep Kotha"]
  spec.email         = ["sandeep.kotha@live.com"]
  spec.summary       = "Fluentd output plugin for Azure Event Hubs"
  spec.description   = "Fluentd output plugin for Azure Event Hubs"
  spec.homepage      = "https://github.com/sio2k/async-fluent-plugin-azureeventhubs"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.name          = "sk-fluent-plugin-azureeventhubs"
  spec.version       = "0.0.24"
  spec.required_ruby_version = ">= 2.1.0"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 13.1"
  spec.add_dependency "fluentd", [">= 0.10.58", "< 2"]
  spec.add_dependency "rest-client", [">= 2.0.2"]
  spec.add_dependency "json", [">= 2.1.0"]
end