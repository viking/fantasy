desc "Run all tests"
task :test do
  require 'test/unit'
  Dir[File.dirname(__FILE__) + "/test/**/test_*.rb"].each do |file|
    require file
  end
end

task :default => :test
