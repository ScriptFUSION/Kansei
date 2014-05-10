require 'test/unit'

require_relative '../lib/kansei/player_collection'

include Kansei

# PlayerCollection tests.
class PlayerCollectionTest < Test::Unit::TestCase
  def setup
    @players = PlayerCollection.new([*1..8])
  end

  def test_current
    assert_same(1, @players.current)
  end

  def test_rotate!
    @players.rotate!
    assert_same(2, @players.current)

    @players.rotate! 2
    assert_same(4, @players.current)
  end

  def test_rotate
    players = @players.rotate
    assert_same(1, @players.current)
    assert_same(2, players.current)
  end

  def test_next
    assert_same(2, @players.next)
    assert_same(1, @players.current)
  end

  def test_change_direction
    assert_same(8, @players.change_direction.next)
    assert_same(2, @players.change_direction.next)
  end
end
