class Genre < ApplicationRecord
    has_many :movies

    validates :name, presence: true

    def self.ransackable_attributes(auth_object = nil)
        ["name"]
    end

    def self.ransackable_associations(auth_object = nil)
        ["movies"]
    end
end
