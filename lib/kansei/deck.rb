module Kansei
  # Contains an ordered collection of cards.
  class Deck < Array
    def initialize(cards = [])
      super
    end

    def draw(n = 1)
      pop n
    end

    def top
      self[-1]
    end
  end
end
