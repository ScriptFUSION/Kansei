require_relative 'game'
require_relative 'player'
require_relative 'repl'

# Entry point.
module Kansei
  module_function

  def start
    game = Game.new
    %w(Player\ 1 Player\ 2).each { |name| game.add_player Player.new(name) }
    game.start

    repl = REPL.new(game)
    repl.cmd 'status'
    repl.start
  end
end

Kansei.start if $PROGRAM_NAME == __FILE__
