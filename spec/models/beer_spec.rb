require 'rails_helper'

RSpec.describe Beer, type: :model do
  it "can be set correctly" do
    test_brewery = Brewery.new name: "test", year: 2000
    beer = Beer.create name: "testbeer", style: "teststyle", brewery: test_brewery

    expect(beer).to be_valid
    expect(Beer.count).to eq(1)
  end

  it "is not saved without a name" do
    test_brewery = Brewery.new name: "test", year: 2000
    beer = Beer.create style: "teststyle", brewery: test_brewery

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end

  it "is not saved without a style" do
    test_brewery = Brewery.new name: "test", year: 2000
    beer = Beer.create name: "testbeer", brewery: test_brewery

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end
end
