require 'rails_helper'

RSpec.describe Review, type: :model do
  it 'is valid with all required attributes' do
    review = build(:review)
    expect(review).to be_valid
  end

  it 'is invalid without a user' do
    review = build(:review, user: nil)
    expect(review).not_to be_valid
    expect(review.errors[:user]).to include("must exist")
  end

  it 'is invalid without a movie' do
    review = build(:review, movie: nil)
    expect(review).not_to be_valid
    expect(review.errors[:movie]).to include("must exist")
  end

  it 'is invalid without a rating' do
    review = build(:review, rating: nil)
    expect(review).not_to be_valid
    expect(review.errors[:rating]).to include("can't be blank")
  end

  it 'is valid without a comment' do
    review = build(:review, comment: nil)
    expect(review).to be_valid
  end

  it 'is invalid with rating less than 1' do
    review = build(:review, rating: 0)
    expect(review).not_to be_valid
    expect(review.errors[:rating]).to include("must be greater than or equal to 1")
  end

  it 'is invalid with rating greater than 5' do
    review = build(:review, rating: 6)
    expect(review).not_to be_valid
    expect(review.errors[:rating]).to include("must be less than or equal to 5")
  end

  it 'belongs to a user' do
    user = create(:user)
    review = create(:review, user: user)
    expect(review.user).to eq(user)
  end

  it 'belongs to a movie' do
    movie = create(:movie)
    review = create(:review, movie: movie)
    expect(review.movie).to eq(movie)
  end
end
