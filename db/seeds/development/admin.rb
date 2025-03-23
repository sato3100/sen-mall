admin_data = [
{
    full_name: "アドミン ユーザー",
    family_name: "アドミン",
    given_name:  "ユーザー",
    email:       "admin@minizon.com",
    password:    "minizon!",
    password_confirmation: "minizon!",
    address:     "神奈川県川崎市多摩区東三田２丁目１−１",
    phone_number: "09012345678",
},
{
    full_name: "アドミン 削除",
    family_name: "削除",
    given_name:  "アドミン",
    email:       "deleteadmin@minizon.com",
    password:    "minizon!",
    password_confirmation: "minizon!",
    address:     "神奈川県川崎市多摩区東三田２丁目１−１",
    phone_number: "09012345678",
}
]

admin_data.each do |admin_attrs|
    admin = Admin.find_or_initialize_by(email: admin_attrs[:email])
    admin.assign_attributes(admin_attrs)
    if admin.new_record?
        admin.save!
        puts "Admin #{admin.email} created!"
    else
        puts "Admin #{admin.email} already exists. Skipping creation."
    end
end