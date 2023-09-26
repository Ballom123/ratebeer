class Brewery < ApplicationRecord
  include RatingAverage

  validates :name, length: { minimum: 1 }
  validates :year, numericality: { greater_than_or_equal_to: 1040,
                                   only_integer: true}
  validate :brewery_year_cannot_be_in_the_future
  
  has_many :beers
  has_many :ratings, through: :beers

  def brewery_year_cannot_be_in_the_future
    if year.present? && year > Date.today.year
      errors.add(:year, "can't be in the future")
    end
  end

  def to_s
    "#{name}"
  end
end
