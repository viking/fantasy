require File.dirname(__FILE__) + "/test_helper"

class TestMatchn < MiniTest::Unit::TestCase
  def test_matchn
    re = %r{(?<foo>\w+)(?<bar>\d+)}
    res = re.matchn("omg huge123 bar", 2)
    assert_kind_of(Array, res)
    assert_equal(2, res.length)
    assert_equal(4, res[0])
    assert_equal($~, res[1])
  end
end
