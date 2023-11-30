class CreateFollowers < ActiveRecord::Migration[7.1]
  def change
    create_table :followers do |t|
      t.references :follower_user, foreign_key: { to_table: :users }
      t.references :following_user, foreign_key: { to_table: :users }
      t.datetime :request_date
      t.timestamps
    end
  end
end
