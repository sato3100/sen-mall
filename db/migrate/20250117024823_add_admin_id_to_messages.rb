class AddAdminIdToMessages < ActiveRecord::Migration[7.0]
  def change
    add_reference :messages, :admin, foreign_key: true, null: true
  end
end
