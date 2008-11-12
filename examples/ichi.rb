require 'benchmark'

$:.unshift(File.dirname(__FILE__) + "/../lib")
require 'fantasy'

$DEBUG = true
Benchmark.bm do |x|
  x.report do
    f = Fantasy.new("http://sports.yahoo.com/nfl/scoreboard") do |config|
      config.for("Passing") do
        give(1).point.per(25, "Yds")
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
    end
    f.run
  end
end
