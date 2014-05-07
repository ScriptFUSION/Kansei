require 'test/unit'

require_relative '../lib/kansei/card'

include Kansei

# Card tests.
class CardTest < Test::Unit::TestCase
  def test_equality
    card = Card.new(:b0)
    card2 = card.dup

    assert_equal(card2, card, 'Instance equality')
    assert_equal(card2, :b0, 'Symbol equality')
  end

  def test_match
    {
      # Suits and numbers.
      b0: :b0, b1: :b2, g0: :b0,
      # Actions.
      yd: :rd, bs: :ys, rr: :gr,
      # Wilds.
      r1: :xw, bd: :xf, xf: :bd,
      # Coloured wilds.
      g3: :gw, b4: :bf
    }.each { |c1, c2| assert(Card.new(c1).match?(c2), "#{c1} == #{c2} ") }
  end

  def test_no_match
    {
      b0: :g1,
      gs: :rr
    }.each { |c1, c2| assert(!Card.new(c1).match?(c2), "#{c1} != #{c2}") }
  end

  def test_name
    assert_equal('Blue Skip', Card.new(:bs).name)
    assert_equal('Yellow 0', Card.new(:y0).name)
    assert_equal('Wild', Card.new(:xw).name)
    assert_equal('Wild Draw Four', Card.new(:xf).name)
  end

  def test_suit
    {
      bs: 'Blue',
      gd: 'Green',
      r1: 'Red',
      y0: 'Yellow',
      xf: nil
    }.each { |id, suit| assert_equal(suit, Card.new(id).suit) }
  end
end
