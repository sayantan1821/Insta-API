class CreateComments < ActiveRecord::Migration[7.1]
  def change
    create_table :comments do |t|
      t.references :post, foreign_key: { to_table: :posts }
      t.references :commentator, foreign_key: { to_table: :users }
      t.string :content
      t.timestamps
    end
  end
end
