require 'test/unit'

require_relative '../lib/kansei/deck'
require_relative '../lib/kansei/card'
require_relative '../lib/kansei/deck_factory'

include Kansei

# Deck tests.
class DeckTest < Test::Unit::TestCase
  def test_new_deck
    deck = Deck.new

    assert_instance_of(Deck, Deck.new)
    assert_same(0, deck.length)
  end

  def test_add_card
    card = Card.new(:b0)
    deck = Deck.new([card])

    assert(deck.include?(card), 'Deck contains card instance')
  end

  def test_concat
    deck = Deck.new([Card.new(:b0)])
    deck << Card.new(:b1)

    assert_instance_of(Deck, deck)
    assert_same(2, deck.length)
  end

  def test_draw
    assert_equal(
      [Card.new(:b3)],
      DeckFactory.create_deck(:b0..:b3).draw,
      'Draw 1'
    )

    assert_equal(
      DeckFactory.create_deck(:b2..:b3),
      DeckFactory.create_deck(:b0..:b3).draw(2),
      'Draw 2'
    )
  end

  def test_top
    deck = DeckFactory.create_deck(:b0..:b3)

    assert_same(4, deck.length)
    assert_equal(Card.new(:b3), deck.top)
    assert_same(4, deck.length)
  end
end
