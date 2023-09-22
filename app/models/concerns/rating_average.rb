module RatingAverage
  extend ActiveSupport::Concern

  def average_rating
    array = ratings.all
    array.average(:score).to_f
  end
end
