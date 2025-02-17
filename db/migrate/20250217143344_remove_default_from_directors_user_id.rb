class RemoveDefaultFromDirectorsUserId < ActiveRecord::Migration[8.0]
  def change
    change_column_default :directors, :user_id, nil
  end
end
