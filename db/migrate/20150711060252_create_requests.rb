class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.string :trap, null: false

      t.text :data, null: false
      t.text :raw, null: false

      t.timestamps null: false
    end
  end
end
