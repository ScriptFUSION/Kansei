module Kansei
  # Ordered collection of Players.
  class PlayerCollection < Array
    def initialize(players = [])
      @direction = 1

      super
    end

    def current
      self[0]
    end

    def change_direction
      @direction = -@direction
    end

    def rotate!(count = 1)
      super count * @direction
    end
  end
end
