class Fantasy
  class Team
    attr_reader :name, :players
    attr_accessor :score
    def initialize(name)
      @name = name
      @players = []
      @score = 0
    end

    def add(player)
      @players << player
    end

    def find_player(name)
      @players.find { |p| p.name == name }
    end
  end
end
