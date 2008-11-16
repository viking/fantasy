require File.dirname(__FILE__) + "/../test_helper"

class TestFantasy < MiniTest::Unit::TestCase
  class TestGame < MiniTest::Unit::TestCase
    include ConfigHelper

    def create_game(num, config = create_config)
      url = "/nfl/boxscore_%03d.html" % num
      g = Fantasy::Game.new(url, config)
      config.fetcher.join
      g
    end

    def test_teams
      game = create_game(7)
      assert_equal("Tennessee", game.home_team.name)
      assert_equal("Green Bay", game.away_team.name)
    end

    def test_team_scores
      game = create_game(7)
      assert_equal(19, game.home_team.score)
      assert_equal(16, game.away_team.score)
    end

    def test_dot_in_team_name
      game = create_game(6)
      assert_equal("St. Louis", game.home_team.name)
      assert_equal("Arizona",   game.away_team.name)
    end

    def test_passing_players
      game = create_game(7)
      kc = game.home_team.find_player("K. Collins")
      refute_nil(kc)
      assert_in_delta(180.0, kc.stats["Passing"]["Yds"])
    end

    def test_rushing_players
      game = create_game(7)
      bj = game.away_team.find_player("B. Jackson")
      refute_nil(bj)
      assert_in_delta(3.0, bj.stats["Rushing"]["Lng"])
    end

    def test_team_defense
      game = create_game(7)
      df = game.home_team.find_player("Defense")
      refute_nil(df)
      assert_in_delta(9.0, df.points)
    end

    def test_kickers
      game = create_game(7)
      player = game.home_team.find_player("R. Bironas")
      refute_nil(player)
      assert_in_delta(13.0, player.points)
    end
  end
end
