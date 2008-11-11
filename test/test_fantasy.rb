require File.dirname(__FILE__) + "/test_helper"

class TestFantasy < MiniTest::Unit::TestCase
  def setup
    @scoreboard = MiniTest::Mock.new
    @scoreboard.expect(:box_scores, ["/foo.txt"])
    Fantasy::Scoreboard.stub!(:new, @scoreboard)

    @game = MiniTest::Mock.new
    Fantasy::Game.stub!(:new, @game)

    @fantasy = Fantasy.new("http://localhost:4331/bar.txt")
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
    skip("TODO")
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

  def teardown
    Fantasy::Scoreboard.unstub!(:new)
    Fantasy::Game.unstub!(:new)
  end
end
