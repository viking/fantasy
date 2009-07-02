#require 'benchmark'

$:.unshift(File.dirname(__FILE__) + "/../lib")
require 'fantasy'

#Benchmark.bm do |x|
#  x.report do
#    f = Fantasy.new("http://sports.yahoo.com/nfl/scoreboard") do |config|
    f = Fantasy.new("http://localhost:4331/nfl/scoreboard.html") do |config|
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
    end
    f.run

    team = f.create_team("Norwegian Pillagers") do
      add "JaMarcus Russell", "Oakland"
      add "Marvin Harrison", "Indianapolis"
      add "Laveranues Coles", "NY Jets"
      add "Bernard Berrian", "Minnesota"
      add "Willie Parker", "Pittsburgh"
      add "Joseph Addai", "Indianapolis"
      add "John Carlson", "Seattle"
      add "Olindo Mare", "Seattle"
      add "Defense", "Baltimore"
    end

    puts "+-----------------+---------+"
    puts "| Player          | Points  |"
    puts "+-----------------+---------+"
    team.players.each do |p|
      puts "| %15s | % 7.2f |" % [p.name, p.points]
    end
    puts "+-----------------+---------+"
    puts "                  | % 7.2f |" % team.points
    puts "                  +---------+"
#  end
#end
