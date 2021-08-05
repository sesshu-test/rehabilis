require 'rails_helper'

RSpec.describe Post, type: :system do

  describe '新規投稿' do
    let(:user) { create(:user) }
    let(:rehabilitation) { build(:rehabilitation) }
    context '新規投稿ができるとき', use_truncation: false do
      it 'ログインしたユーザーは新規投稿できる' do
        # ログインする
        signIn(user)
        # 新規投稿ページへ遷移する
        visit new_post_path
        # フォームに情報を入力する
        click_button '回数系'
        fill_in 'rehabilitations_name', with: rehabilitation.name
        fill_in 'rehabilitations_count', with: rehabilitation.count
        fill_in 'impression', with: rehabilitation.post.impression
        # 投稿するとPostモデルのカウントが1上がる
        expect  do
          find('input[name="commit"]').click
        end.to change { Post.count }.by(1)
        # トップページに遷移する
        expect(current_path).to eq root_path
      end
    end
    context '新規投稿ができないとき' do
      it 'ログインしていないと新規投稿ページに遷移できない' do
        # トップページに遷移する
        visit root_path
        # 新規投稿ページへのリンクがない
        expect(page).to have_no_content('新規投稿')
      end
      it '投稿内容が空だと投稿できない' do
        # ログインする
        signIn(user)
        # 新規投稿ページへ遷移する
        visit new_post_path
        # フォームに情報を入力する
        click_button '回数系'
        fill_in 'rehabilitations_name', with: nil
        fill_in 'rehabilitations_count', with: nil
        fill_in 'impression', with: nil
        expect  do
          find('input[name="commit"]').click
        end.to change { Post.count }.by(0)
        # 新規投稿ページへ戻される
        expect(current_path).to eq '/posts'
      end
    end
  end

  describe '投稿の削除' do
    let(:post1) { create(:post) }
    let(:post2) { create(:post) }
    context '投稿が削除できるとき' do
      it 'ログインしたユーザーは、自分の投稿を削除できる' do
        # post1を投稿したユーザーでログインする
        signIn(post1.user)
        # post1の詳細ページへ遷移する
        visit post_path(post1)
        # 投稿を削除するとレコードの数が1減る
        expect do
          find_link('削除').click
          page.driver.browser.switch_to.alert.accept
          # トップページに遷移する
          expect(current_path).to eq root_path
        end.to change { Post.count }.by(-1)
      end
    end
    context '投稿の削除ができないとき' do
      it 'ログインしたユーザーは、自分以外の投稿を削除できない' do
        # post1を投稿したユーザーでログインする
        signIn(post1.user)
        # post2の詳細ページへ遷移する
        visit post_path(post2)
        # post2の削除ボタンがない
        expect(page).to have_no_link '削除', href: post_path(post2)
      end
      it 'ログインしていないと、投稿の削除ボタンがない' do
        # トップページに移動する
        visit root_path
        # 投稿1の文章をクリックし、投稿1の詳細ページへ遷移する
        visit post_path(post1)
        # 投稿1に削除ボタンが無い
        expect(page).to have_no_link '削除', href: post_path(post1)
      end
    end
  end

  describe '投稿詳細' do
    let(:post) { create(:post) }
    it 'ログインしたユーザーは、投稿詳細ページに遷移してコメント投稿欄が表示される' do
      # ログインする
      signIn(post.user)
      # 投稿の文章をクリックし、投稿詳細ページへ遷移する
      visit post_path(post)
      # コメント用のフォームが存在する
      expect(page).to have_selector 'form'
    end
    it 'ログインしていない状態では、投稿詳細ページに遷移できるものの、コメント投稿欄が表示されない' do
      # トップページに移動する
      visit root_path
      # 投稿の文章をクリックし、投稿詳細ページへ遷移する
      visit post_path(post)
      # コメント用のフォームが存在しない
      expect(page).to have_no_selector 'form'
    end
  end

end