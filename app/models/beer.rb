class Beer < ApplicationRecord
  include Enumerable
  include RatingAverage

  validates :name, length: { minimum: 1, message: "can't be blank" }
  validates :style, presence: true

  belongs_to :style
  belongs_to :brewery
  has_many :ratings, dependent: :destroy
  has_many :raters, -> { distinct }, through: :ratings, source: :user

  def to_s
    "#{name} #{brewery}"
  end

  def average
    return 0 if ratings.empty?

    ratings.map{ :score }.sum / ratings.count.to_f
  end
end
