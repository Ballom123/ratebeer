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

    style_groups = ratings.group_by{ |ratings| ratings.beer.style }
    best_avg = 0
    best_style = ""
    style_groups.each do |style, ratings|
      sum = 0
      count = 0
      ratings.each do |rating|
        sum += rating[:score]
        count += 1
      end
      avg = (sum/count).to_f
      if avg > best_avg
        best_avg = avg 
        best_style = style
      end
    end
    best_style
  end
end
