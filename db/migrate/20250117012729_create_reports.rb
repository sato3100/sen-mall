class CreateReports < ActiveRecord::Migration[7.0]
  def change
    create_table :reports do |t|
      t.integer :reporter_id
      t.integer :reported_user_id
      t.integer :item_id
      t.integer :review_id

      t.timestamps
    end
  end
end
