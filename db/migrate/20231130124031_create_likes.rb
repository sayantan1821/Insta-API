class CreateLikes < ActiveRecord::Migration[7.1]
  def change
    create_table :likes do |t|
      t.references :post, foreign_key: { to_table: :posts }
      t.references :liked_by_user, foreign_key: { to_table: :users }
      t.timestamps
    end
  end
end
