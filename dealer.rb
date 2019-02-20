require_relative 'card'
require_relative 'person'

class Dealer < Person
  attr_accessor :ready

  def show_cards_hidden
    str = ''
    cards.count.times { str += '* ' }
    'Карты Дилера:' << str.chomp
  end

  def ready?
    ready
  end
end
