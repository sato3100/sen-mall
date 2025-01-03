class CreateFavoriteUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :favorite_users do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :favorited_user

      t.timestamps
    end
  end
end
