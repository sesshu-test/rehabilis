# メインのサンプルユーザーを1人作成する
User.create!(name:  "サンプル",
  email: "example@gmail.com",
  password: "foobar",
  confirmed_at: Time.now)

# 追加のユーザーをまとめて生成する
ills = ["骨折", "捻挫", "靭帯損傷", "肺炎"]
99.times do |n|
  name  = Gimei.first.katakana
  email = "example-#{n+1}@gmail.com"
  password = "password"
  user = User.create!(name:  name,
            email: email,
            password: password,
            confirmed_at: Time.now)
  random = rand(3)
  user.ills.create!(name: ills[random])
end

# ユーザーの一部を対象にポストを生成する
users = User.order(:created_at).take(50)
rehabilitations_count = ["スクワット", "腕立て", "腹筋", "背筋"]
rehabilitations_time = ["ランニング", "ジョギング", "ウォーキング", "サイクリング"]
2.times do
  impression = Faker::Lorem.sentence(word_count: 5)
  users.each do |user| 
    post = user.posts.create!(impression: impression)
    # ランダムにリハビリを作成
    random = rand(3)
    rehabilitation = random % 2 == 1? rehabilitations_count[random] : rehabilitations_time[random] 
    post.rehabilitations.create!(name: rehabilitation)
  end
end

 # 最初のユーザがお気に入り登録する
 Like.create(user_id: 1, post_id: 100)

 # 以下のリレーションシップを作成する
users = User.all
user  = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }