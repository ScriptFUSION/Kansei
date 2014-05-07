require_relative 'deck'

module Kansei
  # Represents a Game player.
  class Player
    attr_accessor :name, :hand

    def initialize(name)
      @name = name
      @hand = Deck.new
    end
  end
end
