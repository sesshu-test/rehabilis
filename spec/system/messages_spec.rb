require 'rails_helper'

RSpec.describe 'メッセージ送信', type: :system do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:message) { create(:message) }

  it 'ログインしたユーザーはツイート詳細ページでコメントを投稿できる' do
    # ログインする
    signIn(user)
    # メッセージを送る相手のユーザ詳細ページに遷移する
    visit user_path(other_user)
    #find_link('チャットを始める').click
  end
end