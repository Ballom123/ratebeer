class Beer < ApplicationRecord
  include Enumerable
  include RatingAverage

  validates :name, length: { minimum: 1 }

  belongs_to :brewery
  has_many :ratings, dependent: :destroy

  def to_s
    "#{name} #{brewery.name}"
  end

  def average
    return 0 if ratings.empty?

    ratings.map{ :score }.sum / ratings.count.to_f
  end
end
