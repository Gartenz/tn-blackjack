require_relative 'deck'
require_relative 'player'
require_relative 'dealer'
require_relative 'interface'
require_relative 'bank'

class Game
  attr_accessor :player, :dealer, :deck

  private

  attr_reader :interface, :bank

  public

  INIT_MONEY = 100

  def initialize
    @dealer = Dealer.new('Dealer', INIT_MONEY)
    @bank = Bank.new
    @interface = GameInterface.new
    @player = interface.create_player
  end

  def start
    loop do
      player.money = INIT_MONEY
      dealer.money = INIT_MONEY
      interface.start_game
      @deck = Deck.new
      start_round while player.money > 0 && dealer.money > 0
      interface.show_result(dealer, player)
      break unless continue?
    end
  end

  private

  def continue?
    interface.continue?
  end

  def start_round
    interface.start_round
    dealer.ready = false
    skipped_rounds = 0
    deal_cards
    bank.bet(10, dealer, player)
    loop do
      break if player.cards.count >= 3 && (dealer.cards.count >= 3 || dealer.ready?)

      interface.round_info(bank.money, dealer, player)
      choise = interface.user_choise(skipped_rounds, player)
      player.take_card(deck.give_card) if choise == 2 && player.cards.count < 3
      skipped_rounds += 1 if choise == 1
      break if choise == 3

      dealer_turn
    end
    open_cards
  rescue Deck::DeckEmptyError
    interface.open_deck
    @deck = Deck.new
    retry
  end

  def open_cards
    interface.open_cards(dealer, player)
    winner = check_result
    if winner
      interface.show_winner(bank.money, winner)
      bank.withdraw(winner)
    else
      interface.show_draw
      bank.withdraw(dealer, player)
      return
    end
  end

  def check_result
    dealer_score = dealer.score
    player_score = player.score
    return dealer if player_score > 21 || (dealer_score > player_score && dealer_score <= 21)
    return player if dealer_score > 21 || (dealer_score < player_score && player_score <= 21)

    nil
  end

  def dealer_turn
    return if dealer.cards.count == 3 || dealer.ready?

    if dealer.score >= 17
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
end
