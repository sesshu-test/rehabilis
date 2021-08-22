require 'rails_helper'

RSpec.describe "Notifications", type: :system do
  let(:user) { create(:user) }

  it "通知アイコンをクリックすれば、通知一覧が表示される" do
    # 投稿一覧に遷移
    visit root_path
    # 通知は表示されていない
    expect(page).to have_no_content '通知'
    # ログインして通知アイコンをクリック
    signIn(user)
    click_on '通知'
    # 通知は表示されている
    expect(page).to have_content '通知'
  end
  it "未読の通知があれば未読の表示があり、未読でなくなれば未読の表示が消える" do
    # 投稿一覧に遷移
    visit root_path
    # ログイン
    signIn(user)
    # 未読の表示はない
    expect(page).to have_no_selector '#unchecked_notifications'
    # 通知の作成
    user2 = create(:user)
    post = create(:post)
    create(:notification, visited_id: user.id, visitor_id: user2.id, post_id: post.id, action: "like")
    # 投稿一覧に遷移
    visit root_path
    # 未読の表示がある
    expect(page).to have_selector '#unchecked_notifications'
    click_on '通知'
    # 投稿一覧に遷移
    visit root_path
    # 未読の表示はない
    expect(page).to have_no_selector '#unchecked_notifications'
  end

end
