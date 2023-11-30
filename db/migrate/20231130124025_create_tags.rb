class CreateTags < ActiveRecord::Migration[7.1]
  def change
    create_table :tags do |t|
      t.references :tagged_user, foreign_key: { to_table: :users }
      t.references :post, foreign_key: { to_table: :posts }
      t.timestamps
    end
  end
end
