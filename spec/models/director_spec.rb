require 'rails_helper'

RSpec.describe Director, type: :model do
  it 'is valid with a first_name and last_name' do
    director = build(:director)
    expect(director).to be_valid
  end

  it 'is invalid without a first_name' do
    director = build(:director, first_name: nil)
    expect(director).not_to be_valid
    expect(director.errors[:first_name]).to include("can't be blank")
  end

  it 'is invalid without a last_name' do
    director = build(:director, last_name: nil)
    expect(director).not_to be_valid
    expect(director.errors[:last_name]).to include("can't be blank")
  end

  it 'is valid without a birth_date' do
    director = build(:director, birth_date: nil)
    expect(director).to be_valid
  end

  it 'can have many movies' do
    director = create(:director)
    genre = create(:genre)

    create(:movie, director: director, genre: genre)
    create(:movie, director: director, genre: genre)

    expect(director.movies.count).to eq(2)
  end
end
