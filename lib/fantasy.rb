require 'rubygems'
require 'curb'
require 'uri'

class Fantasy
  class TeamFactory
    attr_reader :team
    def initialize(name, fantasy)
      @team = Team.new(name)
      @fantasy = fantasy
    end

    def run(&block)
      instance_eval(&block)
    end

    def add(player, team)
      t = @fantasy.teams[team]
      @team.add(t.find_player(player))
    end
  end

  attr_reader :scoreboard, :games, :teams, :config
  def initialize(url)
    @url = url
    @config = Config.new(url)
    @teams = {}
    yield @config   if block_given?
  end

  def run
    @config.fetcher.fetch(@url) do |body|
      @scoreboard = Scoreboard.new(body)
      @games = @scoreboard.box_scores.collect { |b| Game.new(b, @config) }
    end
    @config.fetcher.join
    @games.each do |g|
      home = g.home_team; away = g.away_team
      @teams[home.name] = home
      @teams[away.name] = away
    end
  end

  def points_for(*args)
    @config.points_for(*args)
  end

  def create_team(name, &block)
    tf = TeamFactory.new(name, self)
    tf.run(&block)
    tf.team
  end
end

require 'fantasy/config'
require 'fantasy/fetcher'
require 'fantasy/scoreboard'
require 'fantasy/game'
require 'fantasy/player'
require 'fantasy/team'
