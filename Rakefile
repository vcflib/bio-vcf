# encoding: utf-8

require 'rubygems'
require 'rake'

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
