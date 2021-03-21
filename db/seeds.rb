# メインのサンプルユーザーを1人作成する
User.create!(name:  "サンプル",
  email: "example@gmail.com",
  password: "foobar",
  confirmed_at: Time.now)

# 追加のユーザーをまとめて生成する
99.times do |n|
  name  = Gimei.first.katakana
  email = "example-#{n+1}@gmail.com"
  password = "password"
  User.create!(name:  name,
    email: email,
    password: password,
    confirmed_at: Time.now)
end

# ユーザーの一部を対象にマイクロポストを生成する
users = User.order(:created_at).take(6)
50.times do
  impression = Faker::Lorem.sentence(word_count: 5)
  users.each { |user| user.posts.create!(impression: impression) }
end

 # 最初のユーザがお気に入り登録する
 Like.create(user_id: 1, post_id: 300)