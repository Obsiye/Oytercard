
class Oystercard
  attr_reader :balance, :entry_station, :exit_station, :journeys

  DEFAULT_BALANCE = 0
  MINIMUM_BALANCE = 1
  MIN_ERROR = "Cannot travel as balance is below minimum of £#{MINIMUM_BALANCE}".freeze
  MAXIMUM_BALANCE = 90
  MAX_ERROR = "Cannot top up over maximum balance of £#{MAXIMUM_BALANCE}".freeze
  MINIMUM_FARE = 1

  def initialize(balance = DEFAULT_BALANCE)
    @balance = balance
    @journeys = []
  end

  def touch_in(station)
    raise MIN_ERROR if @balance < MINIMUM_BALANCE
    @entry_station = station
  end

  def touch_out(station)
    deduct(MINIMUM_FARE)
    @exit_station = station
    @journeys << {entry_station: entry_station, exit_station: exit_station }
    @entry_station = nil
   
  end

  def in_journey?
    !entry_station.nil?
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
