require_relative 'card'

module Kansei
  # Public Game commands.
  class Command
    def initialize(game)
      @game = game
    end

    def play(card)
      player = @game.players.current
      card = player.hand.find { |c| c == card }
      return "#{player.name} does not have that card" if card.nil?

      @game.play(player, card)

      status "#{player.name} played a #{card.name}"
    rescue => e
      e.message
    end

    def draw
      @game.draw player = @game.players.current

      "#{player.name} drew a #{player.hand.top.name}"
      rescue => e
        e.message
    end

    def pass
      @game.pass player = @game.players.current

      status "#{player.name} passed"
    rescue => e
      e.message
    end

    def card
      "The current card is a #{@game.discard.top.name}"
    end

    def turn
      "It's #{@game.players.current.name}'s turn"
    end

    def hand
      @game.players.current.hand.reduce([]) do |hand, card|
        hand << card.name
      end.join ', '
    end

    def deck
      @game.deck.length
    end

    def status(message = nil)
      [message, '', turn, hand, card].compact.join "\n"
    end

    def help
      'Commands: ' + public_methods(false).join(', ')
    end

    def exit
      nil
    end
  end
end
