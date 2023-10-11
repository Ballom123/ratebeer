require 'rails_helper'

include Helpers

describe "adding through new_beer_path" do
  let!(:brewery) { FactoryBot.create :brewery, name: "Koff" }

  it "works with valid name" do
    visit new_beer_path
    fill_in("beer_name", with: "Test1")
    select("Lager", from: "beer[style]")
    select("Koff", from: "beer[brewery_id]")

    expect{
      click_button "Create Beer"
    }.to change{Beer.count}.from(0).to(1)
    expect(current_path).to eq(beers_path)
  end

  it "does not save beer with empty name" do
    visit new_beer_path
    fill_in("beer_name", with: "")
    select("Lager", from: "beer[style]")
    select("Koff", from: "beer[brewery_id]")
    click_button("Create Beer")

    expect(page).to have_content 'Name is too short (minimum is 1 character)'
    expect(Beer.count).to eq(0)
  end  
end
