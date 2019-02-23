require_relative 'game_rules'

class GameInterface
  def start_round
    puts '---------Начало раунда---------'
  end

  def start_game
    puts '--------Раздача карт--------'
  end

  def open_deck
    puts 'Кончились карты! Раунд прекращен, открытие новой колоды...'
  end

  def round_info(bank_money, dealer, player)
    puts "Банк: #{bank_money}"
    puts dealer.show_cards_hidden
    puts "Деньги Дилера: #{dealer.money}"
    puts "У вас сейчас  очков: #{player.score}"
    puts "Карты: #{player.show_cards}"
    puts "Ваши деньги: #{player.money}"
  end

  def create_player
    puts 'Как зовут Игрока?'
    gets.chomp
  end

  def user_choise(skipped_rounds, player)
    puts 'Ваши действия:'
    puts '1.Пропустить ход' if skipped_rounds.zero?
    puts '2.Добавить карту' if player.cards.count < GameRules::MAX_CARDS
    puts '3.Открыть карты'
    gets.chomp.to_i
  end

  def open_cards(*players)
    puts '--------Открытие карт---------'
    players.each do |player|
      puts "Карты у #{player.name}: #{player.show_cards}"
      puts "Очки #{player.name}: #{player.score}"
    end
  end

  def show_winner(bank_money, winner)
    puts "Банк(#{bank_money}) переходит к #{winner.name}!"
  end

  def show_draw
    puts 'Ничья! Банк распределен между участниками игры.'
  end

  def show_result(dealer, player)
    puts 'Вы выиграли!' if player.money > dealer.money
    puts 'Вы проиграли!' if player.money < dealer.money
    puts 'Ничья!' if player.money == dealer.money
  end

  def continue?
    puts 'Сыграть еще раз? 1.Да 2. Нет'
    gets.chomp.to_i == 1
  end
end
