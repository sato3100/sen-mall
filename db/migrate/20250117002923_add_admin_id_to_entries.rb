class AddAdminIdToEntries < ActiveRecord::Migration[7.0]
  def change
    add_reference :entries, :admin, null: false, foreign_key: true
  end
end
