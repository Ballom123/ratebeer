require 'rails_helper'

include Helpers

describe "User" do
  before :each do
    @user1 = FactoryBot.create :user
  end

  describe "who has signed up" do
    it "can signin with right credentials" do
      sign_in(username: "Pekka", password: "Foobar1")

      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'Pekka'
    end

    it "is redirected back to signin form if wrong credentials given" do
      sign_in(username: "Pekka", password: "wrong")

      expect(current_path).to eq(signin_path)
      expect(page).to have_content 'Username and/or password mismatch'
    end
  end

  it "when signed up with good credentials, is added to the system" do
    visit signup_path
    fill_in('user_username', with: 'Brian')
    fill_in('user_password', with: 'Secret55')
    fill_in('user_password_confirmation', with: 'Secret55')

    expect{
      click_button('Create User')
    }.to change{User.count}.by(1)
  end

  it "shows user's own ratings correctly" do
    # Create another user to test additional ratings do not show
    user2 = FactoryBot.create(:user, username: "Paavo")

    # Login
    sign_in(username: "Pekka", password: "Foobar1")

    # Create ratings, probs want to helper this
    create_beer_with_rating({user: @user1}, 20)
    create_beer_with_rating({user: @user1}, 10)
    # Extra beer not to be expected on user page
    create_beer_with_rating({user: user2}, 30)

    visit user_path(@user1)

    expect(page).to have_content(@user1.ratings.first.to_s)
    expect(page).to have_content(@user1.ratings.last.to_s)
    expect(page).to have_content("2 ratings")
  end
end