require_relative 'deck'
require_relative 'player'
require_relative 'dealer'

class Game
  attr_accessor :player, :dealer, :deck, :bank_money

  INIT_MONEY = 50
  USER_ACTIONS = [].freeze

  def initialize
    @dealer = Dealer.new('Dealer', INIT_MONEY)
    @bank_money = 0
    create_player
  end

  def start
    loop do
      player.money = INIT_MONEY
      dealer.money = INIT_MONEY
      puts '--------Раздача карт--------'
      @deck = Deck.new
      while player.money > 0 && dealer.money > 0
        if deck.count < 6
          puts "В колоде мало карт" 
          break
        end
        self.bank_money = 0
        start_round
      end
      puts 'Вы выиграли!' if player.money > dealer.money
      puts 'Вы проиграли' if player.money < dealer.money
      puts 'Ничья' if player.money == dealer.money
      break unless continue?
    end
  end

  private

  def continue?
    puts 'Сыграть еще раз? 1.Да 2. Нет'
    user_choise = gets.chomp.to_i
    puts user_choise == 1
    user_choise == 1
  end

  def create_player
    puts 'Как зовут Игрока?'
    player_name = gets.chomp
    @player = Player.new(player_name, INIT_MONEY)
  end

  def start_round
    puts '---------Начало раунда---------'
    dealer.ready = false
    skipped_rounds = 0
    deal_cards
    bank_bet(10)
    loop do
      break if player.cards.count >= 3 && (dealer.cards.count >= 3 || dealer.ready?)

      round_info
      puts 'Ваши действия:'
      puts '1.Пропустить ход' if skipped_rounds.zero?
      puts '2.Добавить карту' if player.cards.count < 3
      puts '3.Открыть карты'
      choise = gets.chomp.to_i
      player.take_card(deck.give_card) if choise == 2 && player.cards.count < 3
      skipped_rounds += 1 if choise == 1
      break if choise == 3

      dealer_turn
    end
    open_cards
  end

  def open_cards
    dealer_score = dealer.cards_score
    player_score = player.cards_score
    puts '--------Открытие карт---------'
    puts "Карты у Дилера: #{dealer.show_cards}"
    puts "Очки Дилера: #{dealer_score}"
    puts "Ваши карты: #{player.show_cards}"
    puts "Ваши очки: #{player_score}"
    case check_result(dealer_score, player_score)
    when 0
      puts "Ничья! Банк (#{bank_money}) делиться поровну"
      dealer.money += bank_money / 2
      player.money += bank_money / 2
      return
    when -1
      puts "Выиграл Дилер! Банк (#{bank_money}) переходит к дилеру"
      dealer.money += bank_money
      return
    when 1
      puts "Выиграл Игрок! Банк (#{bank_money}) переходит к игроку"
      player.money += bank_money
      return
    end
  end

  def check_result(dealer_score, player_score)
    return 0 if dealer_score == player_score || (player_score > 21 && dealer_score > 21)
    return -1 if player_score > 21 || (dealer_score > player_score && dealer_score <= 21)
    return 1 if dealer_score > 21 || (dealer_score < player_score && player_score <= 21)
  end

  def dealer_turn
    return if dealer.cards.count == 3 || dealer.ready?
    
    if dealer.cards_score >= 17
      dealer.ready = true
      return
    end
    dealer.take_card(deck.give_card)
  end

  def deal_cards
    unless dealer.cards.count.zero? && player.cards.count.zero?
      dealer.drop_cards
      player.drop_cards
    end
    2.times do
      player.take_card(deck.give_card)
      dealer.take_card(deck.give_card)
    end
  end

  def bank_bet(bet)
    self.bank_money += 2 * bet
    dealer.money -= bet
    player.money -= bet
  end

  def round_info
    puts "Банк: #{bank_money}"
    puts dealer.show_cards_hidden
    puts "Деньги Дилера: #{dealer.money}"
    puts "У вас сейчас  очков: #{player.cards_score}"
    puts "Карты: #{player.show_cards}"
    puts "Ваши деньги: #{player.money}"
  end
end
