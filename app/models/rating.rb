class Rating < ApplicationRecord
    belongs_to :beer

    def to_s
        return "#{self.score}"
    end

end
