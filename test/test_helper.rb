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
  def stub!(name, return_value = nil)
    stub = ObjectStub.new(return_value)
    metaclass.__send__(:define_method, name) { |*args| stub.return_value }
  end

  def unstub!(name)
    metaclass.__send__(:remove_method, name)
  end

  def metaclass
    class << self; self; end
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
