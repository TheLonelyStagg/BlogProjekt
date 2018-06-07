class AddNameToBlogs < ActiveRecord::Migration[5.2]
  def change
    add_column :blogs, :name, :string
  end
end
