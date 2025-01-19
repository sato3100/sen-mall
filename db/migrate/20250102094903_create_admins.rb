class CreateAdmins < ActiveRecord::Migration[7.0]
  def change
    create_table :admins do |t|
      t.string :full_name
      t.string :family_name
      t.string :given_name
      t.string :email
      t.string :password_digest
      t.string :address
      t.string :phone_number

      t.timestamps
    end
  end
end
