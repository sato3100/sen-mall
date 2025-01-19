class ChangeColumnsOfEntries < ActiveRecord::Migration[7.0]
  def up
    change_column_null :entries, :user_id, true  # user_idをnull許可にする
  end

  def down
    change_column_null :entries, :user_id, false
  end
end
