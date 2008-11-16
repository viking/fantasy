require File.dirname(__FILE__) + "/../test_helper"

class TestFantasy < MiniTest::Unit::TestCase
  class TestFetcher < MiniTest::Unit::TestCase
    def setup
      @fetcher = Fantasy::Fetcher.new("http://localhost:4331")
    end

    def test_fetching
      @fetcher.fetch("/foo.txt") do |body|
        assert_equal(body, "foo\n")
      end
      @fetcher.join
    end
  end
end
