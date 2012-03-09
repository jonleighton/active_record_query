# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "ar_query/version"

Gem::Specification.new do |s|
  s.name        = "ar_query"
  s.version     = ARQuery::VERSION
  s.authors     = ["Jon Leighton"]
  s.email       = ["j@jonathanleighton.com"]
  s.homepage    = ""
  s.summary     = %q{Proof of concept for proposed new AR query API}
  s.description = %q{Proof of concept for proposed new AR query API}

  s.rubyforge_project = "ar_query"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'activerecord'

  s.add_development_dependency 'minitest'
  s.add_development_dependency 'mocha'
end
