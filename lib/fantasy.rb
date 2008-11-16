require 'rubygems'
require 'curb'
require 'uri'

class Fantasy
  attr_reader :scoreboard, :games, :config

  def initialize(url)
    @url = url
    @config = Config.new(url)
    yield @config   if block_given?
  end

  def run
    @config.fetcher.fetch(@url) do |body|
      @scoreboard = Scoreboard.new(body)
      @games = @scoreboard.box_scores.collect { |b| Game.new(b, @config) }
    end
    @config.fetcher.join
  end

  def points_for(*args)
    @config.points_for(*args)
  end
end

require 'fantasy/config'
require 'fantasy/fetcher'
require 'fantasy/scoreboard'
require 'fantasy/game'
require 'fantasy/player'
require 'fantasy/team'
