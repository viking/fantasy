require File.dirname(__FILE__) + "/../test_helper"

class TestFantasy < MiniTest::Unit::TestCase
  class TestPlayer < MiniTest::Unit::TestCase
    include ConfigHelper

    def setup
      @player = Fantasy::Player.new("K. Collins", create_config)
    end

    def test_name
      assert_equal("K. Collins", @player.name)
    end

    def test_adding_stats
      @player.via("Passing").add("10", "Comp")
      @player.via("Passing").add("10", "Comp")
      @player.via("Passing").add([["10", "Comp"]])
      assert_in_delta(30.0, @player.stats["Passing"]["Comp"])
    end

    def test_points
      @player.via("Passing").add("180", "Yds")
      @player.via("Passing").add("2", "Sack")
      @player.via("Rushing").add("8", "Yds")
      assert_in_delta(2.0, @player.points)
    end
  end
end
