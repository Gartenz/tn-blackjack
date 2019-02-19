require_relative 'deck'
require_relative 'player'
require_relative 'dealer'

class Game
  attr_accessor :player, :dealer, :deck

  INIT_MONEY = 100
  USER_ACTIONS = ['Пропустить ход', 'Добавить карту', 'Открыть карты'].freeze
  USER_ROUTE = { 1: :skip_turn, 2: :add_card, 3: :show_cards }


  def initialize
    @dealer = Dealer.new('Dealer', INIT_MONEY)
    create_player
    start_game
  end

  private

  def create_player
    puts 'Как зовут Игрока?'
    player_name = gets.chomp
    @player = Player.new(player_name, INIT_MONEY)
  end

  def start_game
    loop do
      @deck = Deck.new
      2.times do
        player.take_card(deck.give_card)
        dealer.take_card(deck.give_card)
      end
      user_choise
    end    
  end

  def user_choise
    puts "У вас сейчас  очков: #{player.cards_value}"
    puts "Карты: #{player.show_cards}"
    puts "Ваши действия:"
    USER_ROUTE.each.with_index(1) { |choise, index| "#{index}. #{choise}"}


  end
end
