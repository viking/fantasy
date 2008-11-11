class Fantasy
  class Player
    attr_reader :name, :stats

    def initialize(name)
      @name = name
      @stats = Hash.new { |h, k| h[k] = {} }
    end

    def via(category)
      @category = category
      self
    end

    def had(num, type)
      @stats[@category][type] = num.to_f
    end
  end
end
