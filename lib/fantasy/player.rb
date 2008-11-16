class Fantasy
  class Player
    attr_reader :name, :stats, :points

    def initialize(name, config)
      @name   = name
      @config = config
      @points = 0.0
      @stats  = Hash.new do |h, k|
        h[k] = Hash.new { |h, k| h[k] = 0.0 }
      end
    end

    def via(category)
      @category = category
      self
    end

    def add(*args)
      stats = args.length == 2 ? [args] : args[0]
      stats.each do |(num, type)|
        num = num.to_f
        @stats[@category][type] += num
        @points += @config.points_for(num, @category, type)
      end
    end
  end
end
