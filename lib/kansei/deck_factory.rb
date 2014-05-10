require_relative 'deck'
require_relative 'card'

module Kansei
  # Creates Decks of Cards.
  module DeckFactory
    module_function

    def create_kansei_deck
      create_deck(
        # Four suits: blue, green, red and yellow.
        %w(b g r y).map do |suit|
          [ # Define half of the cards in this suit.
            *:"#{suit}1"..:"#{suit}9", # Cards 1 through 9.
            # Three actions: draw, reverse and skip.
            %w(d r s).map { |action| :"#{suit + action}" }
          ] * 2 << # Double cards in this definition.
          :"#{suit}0" # One 0 card.
        end.flatten +
        [:xw, :xf] * 4 # Four wild and wild draw four cards.
      )
    end

    def create_deck(cards)
      Deck.new(map_symbols_to_cards(cards))
    end

    def map_symbols_to_cards(symbols)
      symbols.map { |s| Card.new(s) }
    end

    private_class_method :map_symbols_to_cards
  end
end
