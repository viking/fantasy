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

    def find_player_by_full_name(name)
      first, last = name.split
      find_player("#{first[0]}. #{last}")
    end

    def points
      @points ||= @players.inject(0.0) { |s, p| s + p.points }
    end
  end
end
