require_relative 'card'

class Person
  attr_accessor :money
  attr_reader :name, :cards

  def initialize(name, money)
    @name = name
    @money = money
    @cards = []
  end

  def take_card(card)
    cards << card
  end

  def score
    value = 0
    cards.each do |card|
      value += if card.face == 'A' && value > 11
                 1
               else
                 card.value
               end
    end
    value
  end

  def show_cards
    cards.join(' ')
  end

  def drop_cards
    cards.clear
  end
end
