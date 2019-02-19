require_relative 'constants'

class Card
  attr_reader :suit, :face, :value

  def initialize(suit, face)
    @suit = suit
    @face = face
    @value = Constants::CARD_VALUES[face]
  end

  def to_s
    "#{face}#{suit}"
  end

end