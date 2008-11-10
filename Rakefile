require 'fileutils'
include FileUtils

desc "Run all tests"
task :test => :build do
  require 'test/unit'
  Dir[File.dirname(__FILE__) + "/test/**/test_*.rb"].each do |file|
    require file
  end
end

desc "Build project"
task :build do
  libraries  = %w{matchn}
  extensions = %w{so bundle}
  srcdir = File.dirname(__FILE__) + "/ext"
  libdir = File.dirname(__FILE__) + "/lib"
  libraries.each do |library|
    if extensions.all? { |ext| !File.exist?(File.join(srcdir, "#{library}.#{ext}")) }
      if !File.exist?(File.join(srcdir, "Makefile"))
        prev = pwd
        cd srcdir
        system "/usr/local/bin/ruby1.9 extconf.rb"
        cd prev
      end
      `make -C #{srcdir}`
    end
    extensions.each do |ext|
      if File.exist?(sf = File.join(srcdir, "#{library}.#{ext}"))
        cp(sf, libdir, verbose: true)
      end
    end
  end
end

desc "Clean project"
task :clean do
  rm(%w{ext/*.bundle ext/*.so ext/*.o ext/Makefile lib/*.bundle lib/*.so}, force: true, verbose: true)
end
