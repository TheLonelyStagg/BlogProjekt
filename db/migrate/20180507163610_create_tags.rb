class CreateTags < ActiveRecord::Migration[5.2]
  def change
    create_table :tags do |t|
      t.string :tagName

      t.timestamps
    end
  end
end
