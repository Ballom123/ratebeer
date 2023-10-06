class BeerClub < ApplicationRecord
  has_many :memberships, dependent: :destroy
  has_many :mambers, through: :memberships, source: :user
end
