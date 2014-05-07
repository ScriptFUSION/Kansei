require 'test/unit'

require_relative '../lib/kansei/deck_factory'

include Kansei

# DeckFactory tests.
class DeckFactoryTest < Test::Unit::TestCase
  def test_create_deck
    assert_same(108, DeckFactory.create_kansei_deck.length)
  end
end
