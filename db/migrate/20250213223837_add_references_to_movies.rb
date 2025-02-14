class AddReferencesToMovies < ActiveRecord::Migration[8.0]
  def change
    add_reference :movies, :genre, null: false, foreign_key: true
    add_reference :movies, :director, null: false, foreign_key: true
  end
end
