require_relative 'game'
require_relative 'player'
require_relative 'repl'

# Entry point.
module Kansei
  game = Game.new

  game.add_player Player.new('Player 1')
  game.add_player Player.new('Player 2')

  p game

  repl = REPL.new(game)
  repl.cmd 'status'
  repl.start
end
