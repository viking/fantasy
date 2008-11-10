require File.dirname(__FILE__) + "/../test_helper"

class TestFantasy < MiniTest::Unit::TestCase
  class TestTeam < MiniTest::Unit::TestCase

    def setup
      @team = Fantasy::Team.new("Tennessee")
    end

    def test_adding_players
      player = Fantasy::Player.new("K. Collins")
      @team.add(player)
      assert_equal(player, @team.players.first)
    end

    def test_find_player
      player = Fantasy::Player.new("K. Collins")
      @team.add(player)
      assert_equal(player, @team.find_player("K. Collins"))
    end
  end
end
