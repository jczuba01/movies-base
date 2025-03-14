class Actor < ApplicationRecord
    has_many :roles
    has_many :movies, through: :roles

    validates :first_name, presence: true
    validates :last_name, presence: true
end
