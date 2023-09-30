class Membership < ApplicationRecord
  validates :membership, uniqueness: true

  belongs_to :beer_club
  belongs_to :user
end
