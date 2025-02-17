class AddUserIdToGenres < ActiveRecord::Migration[8.0]
  def change
    add_reference :genres, :user, null: false, foreign_key: true, default: 1
  end
end