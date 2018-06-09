class AddCatchedVotesToComents < ActiveRecord::Migration[5.2]
  def change
    change_table :comments do |t|
      t.integer :votes_total, default: 0
      t.integer :votes_score, default: 0
      t.integer :votes_up, default: 0
      t.integer :votes_down, default: 0
    end
  end
end
