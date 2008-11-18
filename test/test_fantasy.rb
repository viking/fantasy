require File.dirname(__FILE__) + "/test_helper"

class TestFantasy < MiniTest::Unit::TestCase
  def setup
    @scoreboard = MiniTest::Mock.new
    @scoreboard.expect(:box_scores, ["/foo.txt"])
    Fantasy::Scoreboard.stub!(:new, @scoreboard)

    @team = MiniTest::Mock.new
    @team.expect(:name, "Leet")

    @game = MiniTest::Mock.new
    @game.expect(:home_team, @team)
    @game.expect(:away_team, @team)
    Fantasy::Game.stub!(:new, @game)

    @fantasy = Fantasy.new("http://localhost:4331/foo.txt")
  end

  def test_passing_config
    @fantasy.config.for("Passing") do
      give(1).point.per(25, "Yds")
      give(6).points.foreach("TD")
      take(2).points.foreach("Int")
      take(1).point.foreach("Sack")
    end
    assert_in_delta( 3.4, @fantasy.points_for( 85, "Passing",   "Yds"))
    assert_in_delta(18.0, @fantasy.points_for(  3, "Passing",   "TD"))
    assert_in_delta(-8.0, @fantasy.points_for(  4, "Passing",   "Int"))
    assert_in_delta(-2.0, @fantasy.points_for(  2, "Passing",   "Sack"))
  end

  def test_rushing_config
    @fantasy.config.for("Rushing") do
      give(1).point.per(20, "Yds")
      give(6).points.foreach("TD")
    end
    assert_in_delta( 6.5, @fantasy.points_for(130, "Rushing",   "Yds"))
    assert_in_delta(12.0, @fantasy.points_for(  2, "Rushing",   "TD"))
  end

  def test_receiving_config
    @fantasy.config.for("Receiving") do
      give(1).point.foreach("Rec")
      give(1).point.per(20, "Yds")
      give(6).points.foreach("TD")
    end
    assert_in_delta( 8.0, @fantasy.points_for(  8, "Receiving", "Rec"))
    assert_in_delta( 6.5, @fantasy.points_for(130, "Receiving", "Yds"))
    assert_in_delta(12.0, @fantasy.points_for(  2, "Receiving", "TD"))
  end

  def test_misc_config
    @fantasy.config.for("Misc") do
      give(2).points.foreach("2Pt")
      take(2).points.foreach("FumL")
    end
    assert_in_delta( 2.0, @fantasy.points_for(  1, "Misc",      "2Pt"))
    assert_in_delta(-4.0, @fantasy.points_for(  2, "Misc",      "FumL"))
  end

  def test_kicking_config
    @fantasy.config.for("Kicking") do
      give(3).points.for( 0..39, "FGMade")
      give(4).points.for(40..49, "FGMade")
      give(5).points.for(50..99, "FGMade")
      take(3).points.for( 0..29, "FGMissed")
      take(2).points.for(30..39, "FGMissed")
      take(1).points.for(40..49, "FGMissed")
      give(1).point.foreach("XPMade")
      take(1).point.foreach("XPMissed")
    end
    assert_in_delta( 3.0, @fantasy.points_for(24, "Kicking", "FGMade"))
    assert_in_delta( 4.0, @fantasy.points_for(47, "Kicking", "FGMade"))
    assert_in_delta( 5.0, @fantasy.points_for(81, "Kicking", "FGMade"))
    assert_in_delta(-3.0, @fantasy.points_for(15, "Kicking", "FGMissed"))
    assert_in_delta(-2.0, @fantasy.points_for(32, "Kicking", "FGMissed"))
    assert_in_delta(-1.0, @fantasy.points_for(45, "Kicking", "FGMissed"))
    assert_in_delta( 3.0, @fantasy.points_for( 3, "Kicking", "XPMade"))
    assert_in_delta(-2.0, @fantasy.points_for( 2, "Kicking", "XPMissed"))
  end

  def test_defense_config
    @fantasy.config.for("Defense") do
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
    assert_in_delta( 3.0, @fantasy.points_for( 3, "Defense", "Sack"))
    assert_in_delta( 4.0, @fantasy.points_for( 2, "Defense", "Int"))
    assert_in_delta( 4.0, @fantasy.points_for( 2, "Defense", "FumR"))
    assert_in_delta( 6.0, @fantasy.points_for( 1, "Defense", "IntTD"))
    assert_in_delta( 2.0, @fantasy.points_for( 1, "Defense", "Safety"))
    assert_in_delta( 2.0, @fantasy.points_for( 1, "Defense", "Blk"))
    assert_in_delta(10.0, @fantasy.points_for( 0, "Defense", "PtsAllowed"))
    assert_in_delta( 7.0, @fantasy.points_for( 3, "Defense", "PtsAllowed"))
    assert_in_delta( 4.0, @fantasy.points_for(12, "Defense", "PtsAllowed"))
    assert_in_delta( 1.0, @fantasy.points_for(17, "Defense", "PtsAllowed"))
    assert_in_delta(-1.0, @fantasy.points_for(28, "Defense", "PtsAllowed"))
    assert_in_delta(-4.0, @fantasy.points_for(47, "Defense", "PtsAllowed"))
  end

  def test_kick_punt_returns_config
    @fantasy.config.for("Kick/Punt Returns") do
      give(6).points.foreach("TD")
    end
    assert_in_delta(6.0, @fantasy.points_for(1, "Kick/Punt Returns", "TD"))
  end

  def test_makes_scoreboard
    @fantasy.run
    assert_equal(@scoreboard, @fantasy.scoreboard)
  end

  def test_makes_games
    @fantasy.run
    assert_equal(1, @fantasy.games.length)
    assert_equal(@game, @fantasy.games.first)
  end

#  def test_team_setup
#    Fantasy::Scoreboard.unstub!(:new)
#    Fantasy::Game.unstub!(:new)
#    fantasy = Fantasy.new("http://localhost:4331/nfl/mini-scoreboard.html")
#    fantasy.run
#    team = fantasy.create_team("Norwegian Pillagers") do
#      add "Kerry Collins", "Tennessee"
#      add "Ryan Grant", "Green Bay"
#    end
#    p team
#    assert_in_delta(48.72, team.points)
#  end

  def teardown
    Fantasy::Scoreboard.unstub!(:new)
    Fantasy::Game.unstub!(:new)
  end
end


