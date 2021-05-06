class CreateCases < ActiveRecord::Migration[6.1]
  def change
    create_table :cases do |t|
      t.references :advocate
      t.references :state
      t.string :number
      t.string :client_name
      t.integer :status
      t.boolean :is_blocked

      t.timestamps
    end
  end
end
