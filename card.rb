class Card
  attr_reader :suit, :face, :value

  def initialize(suit, face, value)
    @suit = suit
    @face = face
    @value = value
  end

  def to_s
    "#{face}#{suit}"
  end
end
