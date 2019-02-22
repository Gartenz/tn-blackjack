require_relative 'card'
require_relative 'person'

class Dealer < Person
  attr_accessor :ready

  def show_cards_hidden
    "Карты Дилера: #{'* ' * cards.count}"
  end

  def ready?
    ready
  end
end
