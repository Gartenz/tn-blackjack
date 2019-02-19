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

  def cards_value
    value = 0
    cards.each do |card|
      value += 1 if card.face == 'A' && value >= 11
      value += card.value
    end
  end

  def show_cards
    str = ''
    cards.each { |card| str += "#{card.to_s} "}
    str.chomp
  end

  def drop_cards
    cards.clear
  end
end
