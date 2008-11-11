class Fantasy
  class Config
    def initialize
      @hash = Hash.new { |h, k| h[k] = {} }
    end

    def [](key)
      @hash[key]
    end

    def for(category, &block)
      @category = category
      self.instance_eval(&block)
      self
    end

    def give(points)
      @points = points
      self
    end

    def take(points)
      @negate = true
      give(points)
    end

    def point
      self
    end
    alias :points :point

    def per(num, type)
      define_recipe(type, [:/, num])
      self
    end

    def foreach(type)
      define_recipe(type, nil)
      self
    end

    # Calculate points
    def points_for(num, category, type)
      r   = @hash[category][type]
      num = num.to_f
      res = (r[:method] ? num.send(*r[:method]) : num) * r[:points]
      r[:negate] ? 0 - res : res
    end

    private
      def define_recipe(type, method)
        @hash[@category][type] = {
          method: method,
          points: @points,
          negate: @negate
        }
        reset!
      end

      def reset!
        @negate = nil
      end
  end
end
