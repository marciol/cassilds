# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "cassandra/version"

Gem::Specification.new do |s|
  s.name = %q{cassilds}
  s.version = Cassandra::VERSION
  s.platform    = Gem::Platform::RUBY
  s.required_rubygems_version = Gem::Requirement.new(">= 0.8") if s.respond_to? :required_rubygems_version=
  s.authors = ["Evan Weaver, Ryan King", "Umanni"]
  s.date = %q{2011-08-22}
  s.default_executable = %q{cassandra_helper}
  s.description = %q{A Ruby client for the Cassandra distributed database.}
  s.email = ["contato@umanni.com"]
  s.executables = [%q{cassandra_helper}]
  s.extra_rdoc_files = [
    "LICENSE",
     "README.md"
  ]

  s.files      = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")

  s.homepage = %q{https://github.com/umanni/cassilds}
  s.rdoc_options = [%q{--line-numbers}, %q{--inline-source}, %q{--title}, %q{Cassandra}, %q{--main}, %q{README.md}]
  s.require_paths = [%q{lib}]
  s.rubygems_version = %q{1.8.5}
  s.summary = %q{A Ruby client for the Cassandra distributed database.}


  s.add_dependency 'thrift'
  s.add_dependency 'thrift_client', '=> 0.7.0'
  s.add_dependency 'json'
  s.add_dependency 'rake'
  s.add_dependency 'simple_uuid', '~> 0.2.0'
  s.add_development_dependency 'eventmachine'
  s.add_development_dependency 'rspec'
end
