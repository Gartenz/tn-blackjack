class Bank
  attr_reader :money

  def initialize
    @money = 0
  end

  def bet(bet, *players)
    players.each do |player|
      player.money -= bet
      self.money += bet
    end
  end

  def withdraw(*players)
    players.each { |player| player.money += money / players.count }
    self.money = 0
  end

  private

  attr_writer :money
end
