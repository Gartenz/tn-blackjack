require_relative 'card'
require_relative 'game_rules'

class Person
  include GameRules

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
    aces_count = 0
    cards.each do |card|
      value += card.cost
      aces_count += 1 if card.ace?
    end
    aces_count.times do
      break if value <= BLACKJACK

      value -= 10 if value > BLACKJACK
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
