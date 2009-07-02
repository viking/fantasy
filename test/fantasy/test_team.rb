require File.dirname(__FILE__) + "/../test_helper"

class TestFantasy < MiniTest::Unit::TestCase
  class TestTeam < MiniTest::Unit::TestCase

    def setup
      @team = Fantasy::Team.new("Tennessee")
      @player = MiniTest::Mock.new
      @player.stub!(:name, "K. Collins")
    end

    def test_adding_players
      @team.add(@player)
      assert_equal(@player, @team.players.first)
    end

    def test_find_player
      @team.add(@player)
      assert_equal(@player, @team.find_player("K. Collins"))
    end

    def test_find_player_by_full_name
      @team.add(@player)
      assert_equal(@player, @team.find_player_by_full_name("Kerry Collins"))
    end

    def test_find_player_by_full_name_with_defense
      defense = MiniTest::Mock.new
      defense.stub!(:name, "Defense")
      @team.add(defense)
      assert_equal(defense, @team.find_player_by_full_name("Defense"))
    end

    def test_score
      @team.score = 27
      assert_equal(27, @team.score)
    end
  end
end
