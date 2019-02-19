require_relative 'card'

class Deck
  CARD_SUITS = ['♣','♥','♦','♠']
  CARD_VALUES = { 2: 2, 3: 3, 4: 4, 5: 5, 6: 6, 7: 7, 8: 8, 9: 9, 10: 10,
                  'J': 10, 'Q': 10, 'K': 10, 'A': 11 }
  
  def initialize
    @cards = []
    CARD_SUITS.each do |suit|
      CARD_VAlUES.each { |face, value| @cards << Card.new(suit, face, value) }
    end
    @cards.shuffle!
  end

  def give_card
    cards.shift
  end

  def count
    cards.count
  end

  private 

  attr_reader :cards
end
