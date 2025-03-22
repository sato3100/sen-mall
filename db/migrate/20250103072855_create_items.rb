class CreateItems < ActiveRecord::Migration[7.0]
  def change
    create_table :items do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.references :category, null: false, foreign_key: true
      t.string :code
      t.integer :stock
      t.string :description
      t.boolean :new
      t.integer :status
      t.integer :price

      t.timestamps
    end
  end
end
