class AddBlogIdToPosts < ActiveRecord::Migration[5.2]
  def change
    add_reference :posts, :blog, foreign_key: true
  end
end
