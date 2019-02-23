require_relative 'card'

class Deck
  class DeckEmptyError < StandardError; end

  CARDS = %w[2 3 4 5 6 7 8 9 10 J Q K A].freeze

  def initialize
    @cards = []
    Card::SUITS.each do |suit|
      CARDS.each { |face| @cards << Card.new(suit, face) }
    end
    @cards.shuffle!
  end

  def give_card
    raise DeckEmptyError if count.zero?

    cards.shift
  end

  def count
    cards.count
  end

  private

  attr_reader :cards
end
