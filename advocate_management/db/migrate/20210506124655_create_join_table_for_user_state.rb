class CreateJoinTableForUserState < ActiveRecord::Migration[6.1]
  def change
    create_join_table :users, :states do |t|
      t.index [:user_id, :state_id]
      t.index [:state_id, :user_id]
    end
  end
end
