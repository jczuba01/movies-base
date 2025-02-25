require 'rails_helper'

RSpec.describe Genre, type: :model do
  it 'is valid with a name' do
    genre = Genre.new(name: 'documentary')
    expect(genre).to be_valid
  end

  it 'can have many movies' do
    genre = Genre.create(name: 'comedy')
    director = Director.create(first_name: 'Kut', last_name: 'As')

    movie1 = Movie.create(
      title: 'Pies',
      description: 'Dog',
      duration_minutes: 997,
      origin_country: 'Poland',
      director: director,
      genre: genre
    )

    movie2 = Movie.create(
      title: 'Kaczor',
      description: 'Duck duck duck',
      duration_minutes: 40,
      origin_country: 'Mozambik',
      director: director,
      genre: genre
    )
  end
end