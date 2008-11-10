class Fantasy
  class Team
    attr_reader :name, :players
    def initialize(name)
      @name = name
      @players = []
    end

    def add(player)
      @players << player
    end

    def find_player(name)
      @players.find { |p| p.name == name }
    end
  end
end
