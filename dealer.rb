require_relative 'card'
require_relative 'person'

class Dealer < Person

  def show_cards_hidden
    str = ''
    cards.count.times { str += '* '}
    str.chomp
  end
end
