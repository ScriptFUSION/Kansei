require_relative 'deck_factory'
require_relative 'deck'
require_relative 'player_collection'

module Kansei
  # Manages game state.
  class Game
    # Current player has just drawn. Only valid moves are play/pass.
    LOCK_DRAW = :d

    attr_accessor :players, :deck, :discard

    def initialize
      @max_players = 10
      @players = PlayerCollection.new
      @discard = Deck.new

      loop do
        @deck = DeckFactory.create_kansei_deck.shuffle!
        # Any card can start the game except Wild Draw 4.
        break unless @deck.top == :xf
      end

      # Place first card on discard pile.
      @discard.concat @deck.draw
    end

    def add_player(player)
      fail 'Too many players' unless @players.length < @max_players

      # Player draws 7 cards at the start.
      draw_cards_to_player player, 7

      @players << player
    end

    def play(player, card)
      validate_play player, card

      @lock = nil
      player.hand.delete(card)
      @discard << card
      @players.rotate!
    end

    def validate_play(player, card)
      check_current_player player
      fail "#{card} is not a card!" unless card.is_a? Card
      fail "#{player.name} does not have #{card.name}" unless
        player.hand.include? card
      fail "#{card.name} does not match the card in play" unless
        @discard.top.match? card
      fail 'Must play the card just drawn or pass' if
        @lock == LOCK_DRAW && !card.equal?(player.hand.top)
    end

    def pass(player)
      check_current_player player
      fail 'Must draw before passing' unless @lock == LOCK_DRAW

      @lock = nil
      @players.rotate!
    end

    def draw(player)
      check_current_player player
      fail 'Cannot draw more than one card each turn: either play or pass' if
        @lock == LOCK_DRAW

      @lock = LOCK_DRAW
      draw_cards_to_player player, 1
    end

    def draw_cards_to_player(player, n)
      player.hand.concat @deck.draw(n)
    end

    def check_current_player(player)
      fail "It is not #{player.name}'s turn" if player != @players.current
    end

    private :validate_play, :draw_cards_to_player, :check_current_player
  end
end
