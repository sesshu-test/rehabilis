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