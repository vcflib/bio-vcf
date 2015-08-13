# encoding: utf-8

require 'rubygems'
require 'rake'

if false
  # Phasing out bundler and jeweler
require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "bio-vcf"
  gem.homepage = "http://github.com/pjotrp/bioruby-vcf"
  gem.license = "MIT"
  gem.summary = %Q{Fast multi-threaded VCF parser}
  gem.description = %Q{Smart lazy multi-threaded parser for VCF format with useful filtering and output rewriting}
  gem.email = "pjotr.public01@thebird.nl"
  gem.authors = ["Pjotr Prins"]
  gem.required_ruby_version = '>=2.0.0'
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new
end

require 'cucumber/rake/task'
Cucumber::Rake::Task.new(:features) do |t|
  # t.cucumber_opts = "--bundler false"
end

task :default => :features

task :test => [ :features ] 

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "bio-vcf #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
