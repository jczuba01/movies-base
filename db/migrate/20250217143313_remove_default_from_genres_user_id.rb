class RemoveDefaultFromGenresUserId < ActiveRecord::Migration[6.0]
  def change
    change_column_default :genres, :user_id, nil
  end
end