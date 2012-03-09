require "bundler/gem_tasks"
require 'rake/testtask'

namespace :test do
  Rake::TestTask.new(:unit) do |t|
    t.libs << "test"
    t.test_files = FileList['test/unit/**/*_test.rb']
    t.verbose = true
  end

  Rake::TestTask.new(:integration) do |t|
    t.libs << "test"
    t.test_files = FileList['test/integration/**/*_test.rb']
    t.verbose = true
  end
end

task :test => ['test:unit', 'test:integration']
task :default => :test
