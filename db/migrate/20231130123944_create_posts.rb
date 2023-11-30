class CreatePosts < ActiveRecord::Migration[7.1]
  def change
    create_table :posts do |t|
      t.string :caption
      t.string :location
      t.references :creator, foreign_key: { to_table: :users }
      t.boolean :is_deleted
      t.timestamps
    end
  end
end
