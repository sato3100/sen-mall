category = ["家電&カメラ", "生活用品・キッチン用品", "ファッション", "書籍", "エンターテイメント", "パソコン・オフィス用品","おもちゃ&ホビー","コスメ・健康・医薬品", "スポーツ・アウトドア","インテリア","楽器","車&バイク"]

category.each do |name|
      Category.create!(
        category_name: name
      )
end