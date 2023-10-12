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
    expect(page.body).not_to have_content(user2.ratings.first.to_s)
  end

  it "shows their favorite brewery" do
    create_beer_with_rating({user: @user1}, 20)

    # Login, go to page
    sign_in(username: "Pekka", password: "Foobar1")
    visit user_path(@user1)

    expect(page).to have_content("Favorite brewery: anonymous")
  end

  it "shows their favorite style" do
    create_beer_with_rating({user: @user1}, 20)

    # Login, go to page
    sign_in(username: "Pekka", password: "Foobar1")
    visit user_path(@user1)

    expect(page).to have_content("Favorite style: Lager")
  end

  it "can delete own ratings from database properly" do
    create_beer_with_rating({user: @user1}, 20)
    create_beer_with_rating({user: @user1}, 40)
    
    # Go to page and delete second rating
    sign_in(username: "Pekka", password: "Foobar1")
    visit user_path(@user1)
    find(:xpath, "(//a[text()='Delete'])[2]").click

    expect(@user1.ratings.count).to eq(1)
    expect(page).to have_content(@user1.ratings.first.to_s)
    expect(page).not_to have_content("anonymous 40")
  end
end