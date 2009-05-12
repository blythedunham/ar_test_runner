

require File.join(File.dirname(__FILE__), '..', 'lib', 'ar_test_runner')

# define a rake task for each adapter
#  rake test:activerecord:mysql
namespace :test do  
  namespace :activerecord do
    ArTestRunner::ADAPTERS.each do |adapter|
      desc "runs ActiveRecord regression unit tests for #{adapter}"
      task adapter.to_sym do |t|
        ENV['DB'] = adapter
        ArTestRunner.run!
      end
    end
  end
end
