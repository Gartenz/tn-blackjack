require_relative 'deck'
require_relative 'player'
require_relative 'dealer'
require_relative 'interface'
require_relative 'bank'
require_relative 'game_rules'

class Game
  include GameRules

  attr_accessor :player, :dealer, :deck

  def initialize
    @dealer = Dealer.new('Dealer', INIT_MONEY)
    @bank = Bank.new
    @interface = GameInterface.new
    player_name = interface.create_player
    @player = Player.new(player_name, INIT_MONEY)
  end

  def start
    loop do
      player.money = INIT_MONEY
      dealer.money = INIT_MONEY
      interface.start_game
      @deck = Deck.new
      start_round while can_bet?
      interface.show_result(dealer, player)
      break unless continue?
    end
  end

  private

  attr_reader :interface, :bank
  attr_accessor :skipped_rounds

  def can_bet?
    player.money > 0 && dealer.money > 0
  end

  def continue?
    interface.continue?
  end

  def start_round
    interface.start_round
    dealer.ready = false
    @skipped_rounds = 0
    deal_cards
    bank.bet(DEFAULT_BET, dealer, player)
    loop do
      break if open_up?

      interface.round_info(bank.money, dealer, player)
      choise = interface.user_choise(skipped_rounds, player)
      break if choise == 3

      proceed_choise(choise)
      dealer_turn
    end
    open_cards
  rescue Deck::DeckEmptyError
    interface.open_deck
    @deck = Deck.new
    retry
  end

  def proceed_choise(choise)
    player.take_card(deck.give_card) if choise == 2 && player.cards.count < MAX_CARDS
    @skipped_rounds += 1 if choise == 1
  end

  def open_up?
    player.cards.count >= MAX_CARDS && (dealer.cards.count >= MAX_CARDS || dealer.ready?)
  end

  # rubocop:disable Metrics/AbcSize
  def open_cards
    interface.open_cards(dealer, player)
    winner = check_result
    if winner
      interface.show_winner(bank.money, winner)
      bank.withdraw(winner)
    else
      interface.show_draw
      bank.withdraw(dealer, player)
    end
  end
  # rubocop:enable Metrics/AbcSize

  def check_result
    dealer_score = dealer.score
    player_score = player.score
    return dealer if player_win?(dealer_score, player_score)
    return player if dealer_win?(dealer_score, player_score)

    nil
  end

  def player_win?(dealer_score, player_score)
    player_score > BLACKJACK || (dealer_score > player_score && dealer_score <= BLACKJACK)
  end

  def dealer_win?(dealer_score, player_score)
    dealer_score > BLACKJACK || (dealer_score < player_score && player_score <= BLACKJACK)
  end

  def dealer_turn
    return if dealer.cards.count == MAX_CARDS || dealer.ready?

    if dealer.score >= DEALER_DUMMY_SCORE
      dealer.ready = true
      return
    end
    dealer.take_card(deck.give_card)
  end

  def deal_cards
    dealer.drop_cards
    player.drop_cards
    2.times do
      player.take_card(deck.give_card)
      dealer.take_card(deck.give_card)
    end
  end
end
