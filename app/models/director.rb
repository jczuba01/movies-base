class Director < ApplicationRecord
    has_many :movies

    validates :first_name, presence: true
    validates :last_name, presence: true

    def self.ransackable_attributes(auth_object = nil)
        [ "last_name" ]
    end

    def self.ransackable_associations(auth_object = nil)
        [ "movies" ]
    end
end
