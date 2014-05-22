require_relative 'deck_factory'
require_relative 'deck'
require_relative 'player_collection'

module Kansei
  # Manages game state.
  class Game
    # Current player has just drawn. Only valid moves are play/pass.
    LOCK_DRAW = :d
    # Wildcard has just been played. Colour must be chosen by player.
    LOCK_WILD = :w
    # Game has ended.
    LOCK_END = :e

    attr_reader :players, :deck, :discard

    def initialize(options = {})
      @max_players = options[:max_players] || 10
      @players = PlayerCollection.new

      reset
    end

    def reset
      @players.each { |player| player.reset }
      @discard = Deck.new
      @lock = nil

      loop do
        @deck = DeckFactory.create_kansei_deck.shuffle!
        # Any card can start the game except Wild Draw 4.
        break unless @deck.top == :xf
      end
    end

    def start
      # Randomly select dealer.
      @players.shuffle!

      # Place first card on discard pile.
      @discard.concat @deck.draw

      process_card_action @discard.top if @discard.top.action?
    end

    def play(player, card)
      validate_play player, card

      # Clear play lock.
      @lock = nil

      # Erase colour of previously played card.
      current_card.colour = nil

      # Remove card from player's hand.
      player.hand.delete card
      # Place card on discard pile.
      @discard << card

      process_card_action card if card.action?

      # Game is over if player has emptied their hand.
      @lock = LOCK_END if player.hand.size == 0

      rotate_players unless @lock
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
      fail 'Cannot draw at this time' if @lock && @lock != LOCK_DRAW

      @lock = LOCK_DRAW
      draw_cards_to_player player, 1
    end

    def wild_colour(player, colour)
      check_current_player player
      fail 'Play a wildcard first' if @lock != LOCK_WILD

      # Clear play lock.
      @lock = nil

      current_card.colour = colour
      @players.rotate!
    end

    def add_player(player)
      fail 'Too many players' unless @players.length < @max_players

      # Player draws 7 cards at the start.
      draw_cards_to_player player, 7

      @players << player
    end

    def current_card
      @discard.top
    end

    private

    def validate_play(player, card)
      check_current_player player

      check_lock player, card if @lock

      fail "#{card} is not a card!" unless card.is_a? Card
      fail "#{player.name} does not have #{card}" unless
        player.hand.include? card
      fail "#{card} does not match the card in play" unless
        current_card.match? card
    end

    def check_current_player(player)
      fail "It is not #{player.name}'s turn" if player != @players.current
    end

    def check_lock(player, card)
      fail 'Game has ended' if @lock == LOCK_END
      fail 'Must play the card just drawn or pass' if
        @lock == LOCK_DRAW && !card.equal?(player.hand.top)
      fail 'Must nominate a wildcard colour' if @lock == LOCK_WILD
    end

    def process_card_action(card)
      @lock = LOCK_WILD if card.wild?

      case card.face
      # Draw two cards to next player.
      when :d then draw_cards_to_player @players.next, 2
      # Reverse play direction.
      when :r then @players.change_direction
      # Draw four cards to next player.
      when :f then draw_cards_to_player @players.next, 4
      end
    end

    def rotate_players
      # Rotate two if skip played or reverse played in two-player mode.
      return @players.rotate! 2 if current_card.face == :s ||
        @players.size == 2 && current_card.face == :r

      # Rotate one.
      @players.rotate!
    end

    def draw_cards_to_player(player, n)
      # TODO: Shuffle discard pile when deck is exhausted.
      player.hand.concat @deck.draw(n)
    end
  end
end
