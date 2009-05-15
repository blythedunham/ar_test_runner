# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{ar_test_runner}
  s.version = "0.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Blythe Dunham"]
  s.date = %q{2009-05-15}
  s.default_executable = %q{ar_test_runner}
  s.description = %q{Run ActiveRecord core regression tests with your code/gem/plugin/module loaded}
  s.email = %q{blythe@snowgiraffe.com}
  s.executables = ["ar_test_runner"]
  s.extra_rdoc_files = ["bin/ar_test_runner", "lib/ar_test_runner.rb", "lib/ar_test_runner_includes.rb", "README.rdoc", "tasks/ar_test_runner_tasks.rake"]
  s.files = ["ar_test_runner.gemspec", "bin/ar_test_runner", "gem_install.rb", "init.rb", "lib/ar_test_runner.rb", "lib/ar_test_runner_includes.rb", "Manifest", "MIT-LICENSE", "Rakefile", "README.rdoc", "tasks/ar_test_runner_tasks.rake", "uninstall.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/blythedunham/ar_test_runner}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Ar_test_runner", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{ar_test_runner}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Run ActiveRecord core regression tests with your code/gem/plugin/module loaded}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
