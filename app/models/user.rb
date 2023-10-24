class User < ApplicationRecord
  include RatingAverage
  include Enumerable

  has_secure_password

  validates :username, uniqueness: true,
                       length: { minimum: 3,
                                 maximum: 30 }
  validates :password, length: { minimum: 4 },
                       format: { with: /\A[A-Z].*\d|\d.*[A-Z]\z/, message: "must include one upper case letter and number" }

  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships

  def favorite_beer
    return nil if ratings.empty?

    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_style
    return nil if ratings.empty?

    styles = group_ratings_by_style
    styles.first.name
  end

  def group_ratings_by_style
    style_groups = ratings.group_by{ |ratings| ratings.beer.style }
    styles_with_averages = {}
    style_groups.each do |style, ratings|
      styles_with_averages.merge!(rating_average(style, ratings))
    end
    styles_with_averages.max_by{ |_k, v| v }
  end

  def favorite_brewery
    return nil if ratings.empty?

    breweries = group_ratings_by_brewery
    breweries.first
  end

  def group_ratings_by_brewery
    brewery_groups = ratings.group_by{ |ratings| ratings.beer.brewery }
    breweries_with_averages = {}
    brewery_groups.each do |brewery, ratings|
      breweries_with_averages.merge!(rating_average(brewery, ratings))
    end
    breweries_with_averages.max_by{ |_k, v| v }
  end

  def rating_average(arg1, ratings)
    # Shared method for averages
    count = ratings.count
    sum = ratings.sum(&:score)
    avg = (sum / count).to_f
    { arg1 => avg }
  end
end
