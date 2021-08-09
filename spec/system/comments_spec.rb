require 'rails_helper'

RSpec.describe 'コメント', type: :system do

  # ログインしていないユーザーは、System/postsにてコメント投稿フォームが表示されないことを確認済み

  let(:user) { create(:user) }
  let(:post) { create(:post) }
  let(:comment) { create(:comment) }
  it 'ログインしたユーザーはツイート詳細ページでコメントを投稿し、それをできる' do
    # ログインする
    signIn(user)
    # 投稿詳細ページに遷移する
    visit post_path(post)
    # フォームに情報を入力する
    fill_in 'comment_content', with: comment.content
    # コメントを送信するとページにコメントが表示され、Commentモデルのカウントが1上がる
    expect  do
      find('input[value="Comment"]').click
      expect(page).to have_content(comment.content)
    end.to change {Comment.count}.by(1)
    # コメントを削除すると、Commentモデルのカウントが1下がる
    expect do
      accept_alert do
        find_link('削除').click
      end
      sleep 1
    end.to change { Comment.count }.by(-1)
    # 投稿詳細のまま
    expect(current_path).to eq post_path(post)
  end
  it 'ログインしたユーザーは他人のコメントは削除できない' do
    # ログインする
    signIn(user)
    # 投稿詳細ページに遷移する
    visit post_path(comment.post)
    # コメントの削除リンクがない
    expect(page).to have_no_link '削除'
  end
  
end
