class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string     :name,     null: false
      t.boolean    :is_enter, null: false, default: true
      t.references :room,     null: false, foreign_key: true

      t.timestamps
    end
    add_index :users, [:name, :room_id], unique: true
  end
end
