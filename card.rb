class Card
  attr_reader :suit, :face

  SUITS = %w[♣ ♥ ♦ ♠].freeze

  def initialize(suit, face)
    @suit = suit
    @face = face
  end

  def cost
    return 11 if ace?
    return 10 if picture?

    face.to_i
  end

  def ace?
    face == 'A'
  end

  def picture?
    %w[J Q K].include?(face)
  end

  def to_s
    "#{face}#{suit}"
  end
end
