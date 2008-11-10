require File.dirname(__FILE__) + "/../test_helper"

class TestFantasy < MiniTest::Unit::TestCase
  class TestPlayer < MiniTest::Unit::TestCase
    def setup
      @player = Fantasy::Player.new("K. Collins")
    end

    def test_name
      assert_equal("K. Collins", @player.name)
    end
  end
end
