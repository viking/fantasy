class Fantasy
  class Config
    class Recipe
      def initialize(options)
        @method  = options[:method]
        @points  = options[:points]
        @negated = options[:negated]
      end

      def calculate(num)
        num = num.to_f
        res = (@method ? num.send(*@method) : num) * @points
        @negated ? 0 - res : res
      end
    end

    class RangedRecipe
      def initialize
        @ranges = {}
      end

      def add(options)
        range = options.delete(:range)
        @ranges[range] = options
      end

      def calculate(num)
        res = nil
        @ranges.each_pair do |range, hsh|
          next  unless range === num
          res = hsh[:negated] ? 0 - hsh[:points] : hsh[:points]
          break
        end
        res
      end
    end

    class Category
      attr_reader :name
      def initialize(name)
        @name = name
        @hash = {}
        @negated = false
      end

      def [](key)
        @hash[key]
      end

      def run(&block)
        instance_eval(&block)
      end

      def give(points)
        @points = points
        self
      end

      def take(points)
        @negated = true
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

      def for(range, type)
        define_ranged_recipe(type, range)
        self
      end

      private
        def define_recipe(type, method)
          @hash[type] = Recipe.new({
            method:  method,
            points:  @points,
            negated: @negated
          })
          reset!
        end

        def define_ranged_recipe(type, range)
          @hash[type] ||= RangedRecipe.new
          @hash[type].add({
            range: range, points: @points, negated: @negated
          })
          reset!
        end

        def reset!
          @negated = nil
        end
    end

    attr_reader :fetcher
    def initialize(url)
      @hash = {}
      @fetcher = Fetcher.new(url)
    end

    def [](key)
      @hash[key]
    end

    def for(category, &block)
      @hash[category] = c = Category.new(category)
      c.run(&block)
    end

    # Calculate points
    def points_for(num, category, type)
      r = @hash[category] ? @hash[category][type] : nil
      r ? r.calculate(num) : 0.0
    end
  end
end
