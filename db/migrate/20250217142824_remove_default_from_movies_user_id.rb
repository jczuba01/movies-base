class RemoveDefaultFromMoviesUserId < ActiveRecord::Migration[8.0]
  def change
    change_column_default :movies, :user_id, nil
  end
end