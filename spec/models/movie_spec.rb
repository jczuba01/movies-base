require 'rails_helper'

RSpec.describe Movie, type: :model do
  it 'is valid with all required attributes' do
    director = Director.create(first_name: 'David', last_name: 'Goggins')
    genre = Genre.create(name: 'romance')

    movie = Movie.new(
      title: 'They dont know me son',
      description: 'Navy',
      duration_minutes: 99,
      origin_country: 'USA',
      director: director,
      genre: genre
    )
    expect(movie).to be_valid
  end

  it 'can have reviews' do
    director = Director.create(first_name: 'Quentin', last_name: 'Tarantino')
    genre = Genre.create(name: 'crime')

    movie = Movie.create(
      title: 'Box',
      description: 'Kox',
      duration_minutes: 433,
      origin_country: 'Argentina',
      director: director,
      genre: genre
    )

    user = User.create(
      email: 'user@example.com',
      password: 'password123'
    )

    Review.create(
      rating: 5,
      comment: 'Top!!!',
      user: user,
      movie: movie
    )

    Review.create(
      rating: 1,
      comment: 'Piece of shit',
      user: user,
      movie: movie
    )
    
    expect(movie.reviews.count).to eq(2)
  end
end