class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.date :data
      t.string :status
      t.boolean :ifTop

      t.timestamps
    end
  end
end
