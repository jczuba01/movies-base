class MovieSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :duration_minutes, :origin_country, 
  :created_at, :updated_at,  :average_rating

  belongs_to :genre
  belongs_to :director
end
