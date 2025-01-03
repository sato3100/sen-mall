class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :full_name
      t.string :family_name
      t.string :given_name
      t.string :business_name
      t.string :email
      t.string :password
      t.string :phonenumber
      t.integer :status

      t.timestamps
    end
  end
end