module RatingAverage
    extend ActiveSupport::Concern

    def average_rating
        array = self.ratings.all
        return (array.average(:score)).to_f
    end


end