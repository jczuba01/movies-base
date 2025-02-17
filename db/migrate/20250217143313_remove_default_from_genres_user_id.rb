class RemoveDefaultFromGenresUserId < ActiveRecord::Migration[8.0]
  def change
    change_column_default :genres, :user_id, nil
  end
end