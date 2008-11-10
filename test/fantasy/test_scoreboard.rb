require File.dirname(__FILE__) + "/../test_helper"

class TestFantasy < MiniTest::Unit::TestCase
  class TestScoreboard < MiniTest::Unit::TestCase
    def setup
      @text = File.read(HTML_DIR + "/nfl/scoreboard.html")
      @scoreboard = Fantasy::Scoreboard.new(@text)
    end

    def test_box_scores
      urls = (0..13).collect { |i| "/nfl/boxscore_%03d.html" % i }
      assert_equal(urls, @scoreboard.box_scores.sort)
    end
  end
end
