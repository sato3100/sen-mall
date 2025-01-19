Admin.create!([
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
])

puts "Admins created!"