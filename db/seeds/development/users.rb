family = ["山田", "佐藤", "鈴木", "田中", "伊藤", "渡辺", "高橋", "山本", "中村", "小林"]
given = ["太郎", "花子", "一郎", "春子", "健一", "次郎", "三郎", "秋子", "夏子", "冬子"]

family_en = ["Yamada", "Sato", "Suzuki", "Tanaka", "Ito", "Watanabe", "Takahashi", "Yamamoto", "Nakamura", "Kobayashi"]


10.times do |i|
    status_value = (i < 3) ? 2 : 1
    user_attrs = {
        full_name: "#{family[i]} #{given[i]}",
        family_name: family[i],
        given_name: given[i],
        business_name: "#{family[i]}ストア",
        #email: "#{family_en[i].downcase}#{i}@example.com",
        email: "user#{i}@example.com",
        password: "minizon1",
        password_confirmation: "minizon1",
        #password: "pass",
        #password_confirmation: "pass",
        address: "東京都新宿区#{i}-#{i}-#{i}",
        phone_number: "0901111#{i}#{i}#{i}",
        status: status_value
    }

    user = User.find_or_initialize_by(email: user_attrs[:email])

    user.assign_attributes(user_attrs)
    if user.new_record?
        user.save!
        puts "User #{user.email} created!"
    else
        puts "User #{user.email} already exists. Skipping creation."
    end
end