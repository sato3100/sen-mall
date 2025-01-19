class ChangeAdminIdNullOnEntries < ActiveRecord::Migration[7.0]
  def up
    change_column_null :entries, :admin_id, true
  end

  def down
    change_column_null :entries, :admin_id, false
  end
end
