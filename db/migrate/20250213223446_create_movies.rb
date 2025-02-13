class CreateMovies < ActiveRecord::Migration[8.0]
  def change
    create_table :movies do |t|
      t.string :title
      t.text :description
      t.integer :duration_minutes
      t.string :origin_country

      t.timestamps
    end
  end
end
