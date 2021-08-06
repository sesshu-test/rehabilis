require 'rails_helper'

RSpec.describe 'コメント投稿', type: :system do
  let(:post) { create(:post) }
  let(:comment) { create(:comment) }

  # ログインしていないユーザーは、System/postsにてコメント投稿フォームが表示されないことを確認済み

  it 'ログインしたユーザーはツイート詳細ページでコメントを投稿できる' do
    # ログインする
    signIn(post.user)
    # 投稿詳細ページに遷移する
    visit post_path(post)
    # フォームに情報を入力する
    fill_in 'comment_content', with: comment.content
    # コメントを送信すると、Commentモデルのカウントが1上がる
    expect  do
      find('input[name="commit"]').click
      sleep 1
    end.to change {Comment.count}.by(1)
    # コメント内容が表示されている
    visit post_path(post)
    expect(page).to have_content(comment.content)
  end
end
