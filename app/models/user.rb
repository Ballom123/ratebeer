class User < ApplicationRecord
  include RatingAverage

  has_secure_password

  validates :username, uniqueness: true,
                       length: { minimum: 3,
                                 maximum: 30 }
  validates :password, length: { minimum: 4 }
  validate :password_requirements

  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships

  def password_requirements
    return unless password.present?

    errors.add :password, "must include at least one upper case letter." unless password =~ /[A-Z]/
    errors.add :password, "must include at least one special character." unless password =~ /[^A-Za-z0-9]+/
  end
end
