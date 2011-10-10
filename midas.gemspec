# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "midas/version"

Gem::Specification.new do |s|
  s.name        = "midas"
  s.version     = Midas::VERSION
  s.authors     = ["Dave M"]
  s.email       = ["dmarti21@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Bind custom data structure behavior to data elements rather than an underlying model.}
  s.description = %q{Model Independent DAta Structure: By binding behavior to the data rather than the model, the behavior for that datastructure becoms portable across models. }

  s.rubyforge_project = "midas"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
  s.add_development_dependency "rspec", "~> 2.6"
end
