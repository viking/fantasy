require 'rubygems'
require 'curb'
require 'uri'

class Fantasy
  attr_reader :scoreboard, :games

  def initialize(url)
    @fetcher = Fetcher.new(url)
    @fetcher.fetch([url]) do |url, body|
      @scoreboard = Scoreboard.new(body)
    end
    @games = []
    @fetcher.fetch(@scoreboard.box_scores) do |url, body|
      @games << Game.new(body)
    end
  end
end

require 'matchn'
require 'fantasy/fetcher'
require 'fantasy/scoreboard'
require 'fantasy/game'
require 'fantasy/player'
require 'fantasy/team'
