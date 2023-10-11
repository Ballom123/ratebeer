require 'rails_helper'

include Helpers

describe "Rating" do
  let!(:brewery) { FactoryBot.create :brewery, name: "Koff" }
  let!(:beer1) { FactoryBot.create :beer, name: "iso 3", brewery:brewery }
  let!(:beer2) { FactoryBot.create :beer, name: "Karhu", brewery:brewery }
  let!(:user) { FactoryBot.create :user }

  before :each do
    sign_in(username: "Pekka", password: "Foobar1")
  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path
    select('iso 3', from: 'rating[beer_id]')
    fill_in('rating[score]', with: '15')

    expect{
      click_button "Create Rating"
    }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end

  it "show correct amount on ratings page" do
    #create ratings for beer1, beer2
    rating1 = FactoryBot.create(:rating, beer: beer1, score: 30, user: user )
    rating2 = FactoryBot.create(:rating, beer: beer2, score: 20, user: user )

    visit ratings_path
    expect(page).to have_content(rating1.to_s)
    expect(page).to have_content(rating2.to_s)
    expect(page).to have_content("Number of ratings: 2")

  end
end
