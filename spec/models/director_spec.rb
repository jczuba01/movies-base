require 'rails_helper'

RSpec.describe Director, type: :model do
  it 'is valid with a first_name and last_name' do
    director = Director.new(first_name: 'Chuj', last_name: 'Muj')
    expect(director).to be_valid
  end

  it 'is valid without a first_name' do
    director = Director.new(first_name: nil, last_name: 'reggiN')
    expect(director).to be_valid
  end

  it 'is valid without a last_name' do
    director = Director.new(first_name: 'Nigeria', last_name: nil)
    expect(director).to be_valid
  end

  it 'can have many movies' do
    director = Director.create(first_name: 'Biały', last_name: 'Murzyn')
    genre = Genre.create(name: 'thriller')

      movie1 = Movie.create(
        title: 'Africa',
        description: 'Water problem',
        duration_minutes: 1111,
        origin_country: 'USA',
        director: director,
        genre: genre
      )

      movie2 = Movie.create(
        title: 'Water',
        description: 'black black white black black',
        duration_minutes: 123,
        origin_country: 'Russia',
        director: director,
        genre: genre
      )
  end
end