module Kansei
  # Public Game commands.
  class Command
    def initialize(game)
      @game = game
    end

    def play(card)
      player = current_player
      card = player.hand.find { |c| c == card }
      return "#{player.name} does not have that card" if card.nil?

      @game.play player, card

      status "#{player.name} played a #{card}"
    rescue => e
      e.message
    end

    def draw
      @game.draw player = current_player

      "#{player.name} drew a #{player.hand.top}"
      rescue => e
        e.message
    end

    def pass
      @game.pass player = current_player

      status "#{player.name} passed"
    rescue => e
      e.message
    end

    def card
      "The current card is a #{@game.current_card}"
    end

    def turn
      "It's #{current_player.name}'s turn"
    end

    def hand
      current_player.hand.join ', '
    end

    def deck
      @game.deck.length
    end

    def status(message = nil)
      [message, '', turn, hand, card].compact.join "\n"
    end

    %w(blue green red yellow).each do |colour|
      define_method(colour) do
        begin
          @game.wild_colour player = current_player, colour[0]
        rescue => e
          return e.message
        end

        status "#{player.name} changed the wildcard colour to #{colour}"
      end

      alias_method colour[0], colour
    end

    def help
      'Commands: ' + public_methods(false).join(', ')
    end

    def exit
      nil
    end

    private

    def current_player
      @game.players.current
    end
  end
end
