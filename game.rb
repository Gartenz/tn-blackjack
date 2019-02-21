require_relative 'deck'
require_relative 'player'
require_relative 'dealer'
require_relative 'interface'

class Game
  attr_accessor :player, :dealer, :deck, :bank_money

  private

  attr_reader :interface

  public

  INIT_MONEY = 100

  def initialize
    @dealer = Dealer.new('Dealer', INIT_MONEY)
    @bank_money = 0
    @interface = GameInterface.new
    @player = interface.create_player
  end

  def start
    loop do
      player.money = INIT_MONEY
      dealer.money = INIT_MONEY
      interface.start_game
      @deck = Deck.new 
      while player.money > 0 && dealer.money > 0
        self.bank_money = 0
        start_round
      end
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
    bank_bet(10)
    loop do
      break if player.cards.count >= 3 && (dealer.cards.count >= 3 || dealer.ready?)

      interface.round_info(bank_money, dealer, player)
      choise = interface.user_choise(skipped_rounds, player)
      player.take_card(deck.give_card) if choise == 2 && player.cards.count < 3
      skipped_rounds += 1 if choise == 1
      break if choise == 3

      dealer_turn
    end
    open_cards
  rescue Deck::DeckEmptyError => e
    interface.open_deck
    @deck = Deck.new
    retry
  end

  def open_cards
    interface.open_cards(dealer, player)
    winner = check_result(dealer, player)
    if winner
      interface.show_winner(bank_money, winner)
      winner.money += bank_money
    else
      interface.show_draw
      dealer.money += bank_money / 2
      player.money += bank_money / 2
      return
    end
  end

  def check_result(dealer, player)
    dealer_score = dealer.cards_score
    player_score = player.cards_score
    return nil if dealer_score == player_score || (player_score > 21 && dealer_score > 21)
    return dealer if player_score > 21 || (dealer_score > player_score && dealer_score <= 21)
    return player if dealer_score > 21 || (dealer_score < player_score && player_score <= 21)
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
end
