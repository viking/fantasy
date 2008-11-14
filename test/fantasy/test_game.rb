require File.dirname(__FILE__) + "/../test_helper"

class TestFantasy < MiniTest::Unit::TestCase
  class TestGame < MiniTest::Unit::TestCase
    include ConfigHelper

    def create_game(num)
      fn = "/nfl/boxscore_%03d.html" % num
      @text = File.read(HTML_DIR + fn)
      Fantasy::Game.new(@text, create_config)
    end

    def test_teams
      game = create_game(7)
      assert_equal("Tennessee", game.home_team.name)
      assert_equal("Green Bay", game.away_team.name)
    end

    def test_dot_in_team_name
      game = create_game(6)
      assert_equal("St. Louis", game.home_team.name)
      assert_equal("Arizona",   game.away_team.name)
    end

    def test_passing_players
      game = create_game(7)
      kc = game.home_team.find_player("K. Collins")
      bj = game.away_team.find_player("B. Jackson")
      refute_nil(kc)
      refute_nil(bj)
      assert_in_delta(180.0, kc.stats["Passing"]["Yds"])
      assert_in_delta(3.0,   bj.stats["Rushing"]["Lng"])
    end

#    def test_score_aggregation
#      game = create_game(7)
#      kc = game.home_team.find_player("K. Collins")
#      assert_in_delta(2.0, kc.points)
#    end
  end
end
