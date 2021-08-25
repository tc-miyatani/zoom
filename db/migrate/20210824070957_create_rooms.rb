class CreateRooms < ActiveRecord::Migration[6.0]
  def change
    create_table :rooms do |t|
      t.string  :title,      null: false
      t.boolean :is_private, null: false, default: false
      t.string  :hashid,     null: false, unique: true

      t.timestamps
    end
  end
end
