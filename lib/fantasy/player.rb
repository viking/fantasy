class Fantasy
  class Player
    attr_reader :name, :stats, :points

    def initialize(name, config)
      @name   = name
      @config = config
      @stats  = Hash.new { |h, k| h[k] = {} }
      @points = 0.0
    end

    def via(category)
      @category = category
      self
    end

    def had(num, type)
      num = num.to_f
      @stats[@category][type] = num
      @points += @config.points_for(num, @category, type)
    end
  end
end
