require File.dirname(__FILE__) + "/test_helper"

class TestFantasy < MiniTest::Unit::TestCase
  def setup
    @scoreboard = MiniTest::Mock.new
    @scoreboard.expect(:box_scores, ["/foo.txt"])
    Fantasy::Scoreboard.stub!(:new, @scoreboard)

    @game = MiniTest::Mock.new
    Fantasy::Game.stub!(:new, @game)

    @fantasy = Fantasy.new("http://localhost:4331/bar.txt") do |config|
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
      end
    end
  end

  def test_passing_config
    assert_in_delta( 3.4, @fantasy.points_for( 85, "Passing",   "Yds"))
    assert_in_delta(18.0, @fantasy.points_for(  3, "Passing",   "TD"))
    assert_in_delta(-8.0, @fantasy.points_for(  4, "Passing",   "Int"))
    assert_in_delta(-2.0, @fantasy.points_for(  2, "Passing",   "Sack"))
    assert_in_delta( 6.5, @fantasy.points_for(130, "Rushing",   "Yds"))
    assert_in_delta(12.0, @fantasy.points_for(  2, "Rushing",   "TD"))
    assert_in_delta( 8.0, @fantasy.points_for(  8, "Receiving", "Rec"))
    assert_in_delta( 6.5, @fantasy.points_for(130, "Receiving", "Yds"))
    assert_in_delta(12.0, @fantasy.points_for(  2, "Receiving", "TD"))
    assert_in_delta( 2.0, @fantasy.points_for(  1, "Misc",      "2Pt"))
    assert_in_delta(-4.0, @fantasy.points_for(  2, "Misc",      "FumL"))
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
