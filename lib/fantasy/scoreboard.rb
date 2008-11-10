class Fantasy
  class Scoreboard
    attr_reader :box_scores

    def initialize(body)
      @box_scores = body.scan(%r{href="(/nfl/boxscore.+?)"}).flatten
    end
  end
end
