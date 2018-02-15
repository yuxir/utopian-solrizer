lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'utopian_solrizer/version'

Gem::Specification.new do |s|
  s.name        = 'utopian_solrizer'
  s.version     = UtopianSolrizer::VERSION
  s.date        = '2018-02-07'
  s.summary     = "Utopian Solrizer"
  s.description = "A lightweight tool for indexing Utopian posts into solr."
  s.authors     = ["Yuxi"]
  s.files       = ["lib/utopian_solrizer.rb"]
  s.homepage    =
    'http://rubygems.org/gems/utopian_solrizer'
  s.license       = 'MIT'

  s.add_runtime_dependency 'rsolr', '~> 2.1'
  s.add_runtime_dependency 'activesupport'
  s.add_runtime_dependency 'utopian_ruby_api', '~> 0.0.3'
  s.add_development_dependency 'rspec', '~> 3.7'
end
