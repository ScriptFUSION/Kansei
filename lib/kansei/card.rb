module Kansei
  # A playing card.
  class Card
    SUIT = {
      b: 'Blue',
      g: 'Green',
      r: 'Red',
      y: 'Yellow'
    }

    ACTION = {
      d: 'Draw Two',
      r: 'Reverse',
      s: 'Skip',
      w: 'Wild',
      f: 'Wild Draw Four'
    }

    attr_reader :id, :colour
    alias_method :to_sym, :id

    def initialize(id)
      fail "Invalid ID: #{id}" unless valid? id

      @id = id.to_sym
      @colour = nil
    end

    def ==(other)
      @id == other.to_sym
    end

    def match?(other)
      # If either has a blank suit they always match.
      return true if !suit? || !other.suit?

      # Matching suits or faces.
      suit == other.suit || face == other.face
    end

    def colour=(colour)
      if colour
        colour = colour.to_sym

        fail 'Colour can only be set on wildcards' unless wild?
        fail %(Invalid colour: "#{colour}") unless SUIT.include? colour
      end

      @colour = colour
    end

    def name
      "#{suit_name} #{face_name}".lstrip
    end
    alias_method :to_s, :name

    def suit_name
      SUIT[suit] if suit?
    end

    def action_name
      ACTION[face] if action?
    end

    def face_name
      action_name || face
    end

    def suit
      return @colour if wild?

      @id[0].to_sym
    end

    def face
      @id[1].to_sym
    end

    def suit?
      SUIT.include? suit
    end

    def action?
      ACTION.include? face
    end

    def wild?
      @id[0] == 'x'
    end

    private

    def valid?(id)
      id =~ /\A(?:[bgry][drs\d]|x[wf])\z/
    end
  end
end
