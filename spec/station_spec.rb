require 'station'

describe Station do
  
  let(:station) { Station.new("Barbican", 1) }

  it "expect to return it's name" do
    expect(station.name).to eq ("Barbican")
  end


end
