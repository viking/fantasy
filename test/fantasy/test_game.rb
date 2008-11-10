require File.dirname(__FILE__) + "/../test_helper"

class TestFantasy < MiniTest::Unit::TestCase
  class TestGame < MiniTest::Unit::TestCase
    def setup
      @text = File.read(HTML_DIR + "/nfl/boxscore_007.html")
      @game = Fantasy::Game.new(@text)
    end

    def test_teams
      assert_equal("Tennessee", @game.home_team.name)
      assert_equal("Green Bay", @game.away_team.name)
    end

    def test_passing_players
      kc = @game.home_team.find_player("K. Collins")
      refute_nil(kc)
    end
  end
end
