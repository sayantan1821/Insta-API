class CreateContents < ActiveRecord::Migration[7.1]
  def change
    create_table :contents do |t|
      t.references :post, foreign_key: { to_table: :posts }
      t.string :content_type
      t.string :content_url
      t.timestamps
    end
  end
end
