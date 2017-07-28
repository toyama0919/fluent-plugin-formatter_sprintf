# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "fluent-plugin-formatter_sprintf"
  s.version     = "0.1.0"
  s.authors     = ["Hiroshi Toyama"]
  s.email       = ["toyama0919@gmail.com"]
  s.homepage    = "https://github.com/toyama0919/fluent-plugin-formatter_sprintf"
  s.summary     = "Fluentd Free formatter plugin, Use sprintf."
  s.description = s.summary
  s.licenses    = ["MIT"]

  s.rubyforge_project = "fluent-plugin-formatter_sprintf"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "fluentd"
  s.add_development_dependency "rake"
  s.add_development_dependency "test-unit"
  s.add_development_dependency "pry"
  s.add_development_dependency "pry-nav"
end
