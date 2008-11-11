require 'rubygems'
require 'curb'
require 'uri'

class Fantasy
  attr_reader :scoreboard, :games, :config

  def initialize(url)
    @url = url
    @fetcher = Fetcher.new(url)
    @config = Config.new
    yield @config   if block_given?
  end

  def run
    @fetcher.fetch([@url]) do |url, body|
      @scoreboard = Scoreboard.new(body)
    end
    @games = []
    @fetcher.fetch(@scoreboard.box_scores) do |url, body|
      @games << Game.new(body)
    end
  end

  def points_for(*args)
    @config.points_for(*args)
  end
end

require 'matchn'
require 'fantasy/config'
require 'fantasy/fetcher'
require 'fantasy/scoreboard'
require 'fantasy/game'
require 'fantasy/player'
require 'fantasy/team'
