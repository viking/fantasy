require 'minitest/unit'
require 'minitest/mock'
require 'test/unit'

HTML_DIR = File.expand_path(File.dirname(__FILE__) + "/fixtures/html")

class ObjectStub
  attr_reader :return_value

  def initialize(return_value)
    @return_value = return_value
  end
end

class Object
  # The hidden singleton lurks behind everyone
  def metaclass; class << self; self; end; end
  def meta_eval &blk; metaclass.instance_eval &blk; end

  # Adds methods to a metaclass
  def meta_def name, &blk
    meta_eval { define_method name, &blk }
  end

  # Defines an instance method within a class
  def class_def name, &blk
    class_eval { define_method name, &blk }
  end

  def stub!(name, return_value = nil)
    stub = ObjectStub.new(return_value)
    blk  = proc { |*args| stub.return_value }
    meta_eval do
      if instance_methods(false).include?(name)
        alias_method(:"__stubbed_#{name}", name)
      end
      define_method(name, &blk)
    end
  end

  def unstub!(name)
    meta_eval do
      if instance_methods(false).include?(name)
        remove_method(name)
        if instance_methods(false).include?(:"__stubbed_#{name}")
          alias_method(name, :"__stubbed_#{name}")
          remove_method(:"__stubbed_#{name}")
        end
      end
    end
  end
end

module ConfigHelper
  def create_config
    config = Fantasy::Config.new('http://localhost:4331/nfl/scoreboard.html')
    config.for("Passing") do
      give(1).point.per(50, "Yds")
      give(6).points.foreach("TD")
      take(2).points.foreach("Int")
      take(1).point.foreach("Sack")
    end
    config.for("Rushing") do
      give(1).point.per(20, "Yds")
      give(6).points.foreach("TD")
    end
    config.for("Receiving") do
      give(1).point.foreach("Rec")
      give(1).point.per(20, "Yds")
      give(6).points.foreach("TD")
    end
    config.for("Misc") do
      give(2).points.foreach("2Pt")
      take(2).points.foreach("FumL")
    end
    config.for("Kicking") do
      give(3).points.for( 0..39, "FGMade")
      give(4).points.for(40..49, "FGMade")
      give(5).points.for(50..99, "FGMade")
      take(3).points.for( 0..29, "FGMissed")
      take(2).points.for(30..39, "FGMissed")
      take(1).points.for(40..49, "FGMissed")
      give(1).point.foreach("XPMade")
      take(1).point.foreach("XPMissed")
    end
    config.for("Defense") do
      give(1).point.foreach("Sack")
      give(2).points.foreach("Int")
      give(2).points.foreach("FumR")
      give(6).points.foreach("IntTD")
      give(2).points.foreach("Safety")
      give(2).points.foreach("Blk")
      give(10).points.for(0..0, "PtsAllowed")
      give(7).points.for(1..6, "PtsAllowed")
      give(4).points.for(7..13, "PtsAllowed")
      give(1).point.for(14..20, "PtsAllowed")
      take(1).point.for(21..34, "PtsAllowed")
      take(4).point.for(35..99, "PtsAllowed")
    end
    config.for("Kick/Punt Returns") do
      give(6).points.foreach("TD")
    end
    config
  end
end

$:.unshift(File.dirname(__FILE__) + "/../lib")
require 'fantasy'
