module Kansei
  # Ordered collection of Players.
  class PlayerCollection < Array
    def initialize(players = [])
      @direction = 1

      super
    end

    alias_method :current, :first

    def next
      rotate.current
    end

    def change_direction
      @direction = -@direction

      self
    end

    def rotate(count = 1)
      dup.rotate! count
    end

    def rotate!(count = 1)
      super count * @direction
    end
  end
end
