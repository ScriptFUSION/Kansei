module Kansei
  # A playing card.
  class Card
    SUIT = {
      b: 'Blue',
      g: 'Green',
      r: 'Red',
      y: 'Yellow',
      x: ''
    }

    ACTION = {
      d: 'Draw Two',
      r: 'Reverse',
      s: 'Skip',
      w: 'Wild',
      f: 'Wild Draw Four'
    }

    attr_reader :id
    alias_method :to_sym, :id

    def initialize(id)
      fail "Invalid ID #{id}" unless valid? id

      @id = id.to_sym
    end

    def valid?(id)
      id =~ /^([bgry][drs\d]|x[wf])$/
    end

    def ==(other)
      @id == other.to_sym
    end

    def match?(other)
      # Other can be Card or Symbol.
      other = other.to_sym

      # Wilds always match.
      return true if @id[0] == 'x' || other[0] == 'x'

      # Matching suits or numbers/actions.
      @id[0] == other[0] || @id[1] == other[1]
    end

    def name
      action = @id[1].to_sym
      action = ACTION[action] if ACTION.include? action

      "#{suit} #{action}".lstrip
    end

    def suit
      suit = SUIT[@id[0].to_sym]
      suit if suit.length > 0
    end
  end
end
