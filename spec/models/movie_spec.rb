require 'rails_helper'
require 'factory_bot'

RSpec.describe Movie, type: :model do
  it 'is valid with all required attributes' do
    movie = build(:movie)
    expect(movie).to be_valid
  end

  it 'is invalid without a title' do
    movie = build(:movie, title: nil)
    expect(movie).not_to be_valid
    expect(movie.errors[:title]).to include("can't be blank")
  end

  it 'is valid without a description' do
    movie = build(:movie, description: nil)
    expect(movie).to be_valid
  end

  it 'is invalid without duration_minutes' do
    movie = build(:movie, duration_minutes: nil)
    expect(movie).not_to be_valid
    expect(movie.errors[:duration_minutes]).to include("can't be blank")
  end

  it 'is valid without an origin_country' do
    movie = build(:movie, origin_country: nil)
    expect(movie).to be_valid
  end

  it 'is invalid without a director' do
    movie = build(:movie, director: nil)
    expect(movie).not_to be_valid
    expect(movie.errors[:director]).to include("must exist")
  end

  it 'is invalid without a genre' do
    movie = build(:movie, genre: nil)
    expect(movie).not_to be_valid
    expect(movie.errors[:genre]).to include("must exist")
  end

  it 'can have reviews' do
    movie = create(:movie)
    user = create(:user)

    create(:review, movie: movie, user: user)
    create(:review, movie: movie, user: user)

    expect(movie.reviews.count).to eq(2)
  end
end
