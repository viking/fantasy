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

  def test_makes_scoreboard
    assert_equal(@scoreboard, @fantasy.scoreboard)
  end

  def test_makes_games
    assert_equal(1, @fantasy.games.length)
    assert_equal(@game, @fantasy.games.first)
  end

  def teardown
    Fantasy::Scoreboard.unstub!(:new)
    Fantasy::Game.unstub!(:new)
  end
end
