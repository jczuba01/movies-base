require 'rails_helper'

RSpec.describe Genre, type: :model do
  it 'is valid with a name' do
    genre = build(:genre)
    expect(genre).to be_valid
  end

  it 'is invalid without a name' do
    genre = build(:genre, name: nil)
    expect(genre).not_to be_valid
    expect(genre.errors[:name]).to include("can't be blank")
  end

  it 'can have many movies' do
    genre = create(:genre)
    director = create(:director)

    create(:movie, genre: genre, director: director)
    create(:movie, genre: genre, director: director)
    
    expect(genre.movies.count).to eq(2)
  end
end