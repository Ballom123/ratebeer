require 'rails_helper'

RSpec.describe User, type: :model do
  it "has the username set correctly" do
    user = User.new username: "Pekka"

    expect(user.username).to eq("Pekka")
  end

  it "is not saved without a password" do
    user = User.create username: "Pekka"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  describe "with a proper password" do
    let(:user) { FactoryBot.create(:user) }
  
    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end
  
    it "and with two ratings, has the correct average rating" do
      FactoryBot.create(:rating, score: 10, user: user)
      FactoryBot.create(:rating, score: 20, user: user)
  
      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end

  describe "with faulty password" do
    let(:user){ User.new username: "Pekka"}

    it "is not saved if too short" do
      user.password = "Se1"
      user.password_confirmation = "Se1"

      expect(user).not_to be_valid
      expect(User.count).to eq(0)
    end

    it "is not saved if contains no letters" do
      user.password = "1234567"
      user.password_confirmation = "1234567"
  
      expect(user).not_to be_valid
      expect(User.count).to eq(0)
    end
  end

  describe "favorite beer" do
    let(:user){ FactoryBot.create(:user) }
  
    it "has method for determining the favorite beer" do
      expect(user).to respond_to(:favorite_beer)
    end

    it "without ratings does not have a favorite beer" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = FactoryBot.create(:beer)
      rating = FactoryBot.create(:rating, score: 20, beer: beer, user: user)
    
      expect(user.favorite_beer).to eq(beer)
    end

    it "if several rated, shows correct beer" do
      create_beers_with_many_ratings({user: user}, 10, 20, 15, 7, 9)
      best = create_beer_with_rating({ user: user }, 25 )

      expect(user.favorite_beer).to eq(best)
    end
  end

  describe "favorite style" do
    let(:user){ FactoryBot.create(:user) }

    it "has method for determining the favorite style" do
      expect(user).to respond_to(:favorite_style)
    end

    it "without ratings does not have a favorite style" do
      expect(user.favorite_style).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = FactoryBot.create(:beer)
      rating = FactoryBot.create(:rating, score: 20, beer: beer, user: user)
    
      expect(user.favorite_style).to eq(beer.style)
    end

    it "is the style with highest rating average if several rated" do
      create_beers_with_different_style_or_rating({user: user}, [10, 15, 13, 30, 40], ["Lager", "Lager", "Lager", "IPA", "IPA"])
      best = "IPA"

      expect(user.favorite_style).to eq(best)
    end
  end

  describe "favorite brewery" do
    let(:user){ FactoryBot.create(:user) }

    it "has method for determining the favorite brewery" do
      expect(user).to respond_to(:favorite_brewery)
    end

    it "without ratings does not have a favorite brewery" do
      expect(user.favorite_brewery).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = FactoryBot.create(:beer)
      rating = FactoryBot.create(:rating, score: 20, beer: beer, user: user)
    
      expect(user.favorite_style).to eq(beer.style)
    end

    it "is the style with highest rating average if several rated" do
      brew1 = FactoryBot.create(:brewery)
      brew2 = FactoryBot.create(:brewery, name: "test2")
      create_beers_with_many_ratings_and_dif_breweries({user: user}, [10, 20, 15, 7, 9], [brew1, brew2, brew2, brew1, brew1])
      best = brew2

      expect(user.favorite_brewery).to eq(best)
    end
  end
end

def create_beer_with_rating(object, score)
  beer = FactoryBot.create(:beer)
  FactoryBot.create(:rating, beer: beer, score: score, user: object[:user] )
  beer
end

def create_beers_with_many_ratings(object, *scores)
  scores.each do |score|
    create_beer_with_rating(object, score)
  end
end

def create_beers_with_different_style_or_rating(object, scores, styles)
  scores.zip(styles) do | score, style |
    beer = FactoryBot.create(:beer, style: style)
    FactoryBot.create(:rating, beer: beer, score: score, user: object[:user])
  end
end

def create_beers_with_many_ratings_and_dif_breweries(object, scores, breweries)
  scores.zip(breweries) do | score, brewery |
    beer = FactoryBot.create(:beer, brewery: brewery)
    FactoryBot.create(:rating, beer: beer, score: score, user: object[:user])
  end
end
