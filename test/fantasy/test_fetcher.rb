require File.dirname(__FILE__) + "/../test_helper"

class TestFantasy < MiniTest::Unit::TestCase
  class TestFetcher < MiniTest::Unit::TestCase
    def setup
      @fetcher = Fantasy::Fetcher.new("http://localhost:4331")
    end

    def test_fetching
      urls, bodies = [], []
      @fetcher.fetch(["/foo.txt", "/bar.txt"]) do |url, body|
        urls   << url
        bodies << body
      end
      assert_equal(urls.sort, %w{http://localhost:4331/foo.txt http://localhost:4331/bar.txt}.sort)
      assert_equal(bodies.sort, ["foo\n", "bar\n"].sort)
    end
  end
end
