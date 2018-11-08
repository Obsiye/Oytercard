require 'station'
require 'journey'

class Oystercard
  attr_reader :balance, :this_journey, :history

  DEFAULT_BALANCE = 0
  MINIMUM_BALANCE = 1
  MIN_ERROR = "Cannot travel as balance is below minimum of £#{MINIMUM_BALANCE}".freeze
  MAXIMUM_BALANCE = 90
  MAX_ERROR = "Cannot top up over maximum balance of £#{MAXIMUM_BALANCE}".freeze
  MINIMUM_FARE = 1

  def initialize(balance = DEFAULT_BALANCE)
    @balance = balance
    @history = []
  end

  def touch_in(station)
    raise MIN_ERROR if @balance < MINIMUM_BALANCE
    history << Journey.new(station)
  end

  def touch_out(station)
    deduct(MINIMUM_FARE)
    @history.last.finish_journey(station)
  end

  def in_journey?
    # !entry_station.nil?
  end

  def top_up(amount)
    raise MAX_ERROR if @balance + amount > MAXIMUM_BALANCE

    @balance += amount
  end
  
  private

  def deduct(amount)
    @balance -= amount
  end
end
