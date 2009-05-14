require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'echoe'
desc 'Default: run unit tests.'
task :default => :test

desc 'Test the ar_test_runner plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generate documentation for the ar_regress_test plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'ArTestRunner'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

desc "Install the application"
task :install do
  ruby "gem_install.rb"
end

Echoe.new('ar_test_runner', '0.1.0') do |p|
  p.description    = "Run ActiveRecord core regression tests with your code/gem/plugin/module loaded"
  p.url            = "http://github.com/blythedunham/ar_test_runner"
  p.author         = "Blythe Dunham"
  p.email          = "blythe@snowgiraffe.com"
  p.ignore_pattern = ["tmp/*", "script/*"]
  p.development_dependencies = []
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }
