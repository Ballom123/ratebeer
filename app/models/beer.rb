class Beer < ApplicationRecord
    include Enumerable

    belongs_to :brewery
    has_many :ratings, dependent: :destroy

    def average_rating
        array = Rating.where "beer_id= #{self.id}"
        return (array.average(:score)).to_f
    end

    def total_ratings
        array = Rating.where "beer_id= #{self.id}"
        sum = array.size
        return sum
    end

    def to_s 
        return "#{self.name} #{self.brewery.name}"
    end

end