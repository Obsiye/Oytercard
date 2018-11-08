require 'oystercard'

describe Oystercard do

  let(:min) {Oystercard::MINIMUM_BALANCE}
  let(:max) {Oystercard::MAXIMUM_BALANCE}
  let(:station) { double("station") }

  describe '#top_up' do
    it 'should be able to be topped up with an amount' do
      subject.top_up(5)
      expect(subject.balance).to eq 5
    end

    it 'should not be possible top up over the maximum balance' do
      error = Oystercard::MAX_ERROR
      expect { subject.top_up(max + 5) }.to raise_error(RuntimeError, error)
    end
  end

#   it 'expects journey array to default to empty' do
#     expect(subject.history.last).to be_empty
#   end

  describe 'touch_in(station)' do

    it 'should be able to touch in and start journey' do
      subject.top_up(5)
      subject.touch_in(station)
      expect(subject.history.last.entry_station).to eq station
    end
  
    context 'when balance is below minimum balance' do
      it 'should not start journey' do
        error = Oystercard::MIN_ERROR
        subject.top_up(min - 0.1)
        expect { subject.touch_in(station) }.to raise_error(RuntimeError, error)
      end
    end

    it 'should remember entry station' do
      subject.top_up(5)
      station.stub(:name => "Barbican")
      subject.touch_in(station)
      last_station = subject.history.last
      expect(last_station.entry_station.name).to eq("Barbican")
    end

  end

  describe 'touch_out(station)' do
    before(:each) do
      subject.top_up(5)
      subject.touch_in(station)
    end
    it 'should be able to touch out and stop journey' do
      station.stub(:name => "Barbican")
      subject.touch_out(station)
      last_station = subject.history.last
      expect(last_station.exit_station.name).to eq "Barbican"
    end

    it 'should deduct minimum fare from balance' do
      expect { subject.touch_out(station)}.to change { subject.balance}.from(5).to(4)
    end

  end

  context 'in a journey' do
    before(:each) do
      subject.top_up(5)
      station.stub(:name => "Wican")
      subject.touch_in(station)
      @last_station = subject.history.last
    end
        context 'touched in' do
            it 'has current journey entry station' do
                expect(@last_station.entry_station.name).to eq "Wican"
            end
        end

        context 'touched out' do
            it 'has exit station in current journey' do
                subject.touch_out(station)
                expect(@last_station.exit_station.name).to eq "Wican"
            end
        end
  end



end
