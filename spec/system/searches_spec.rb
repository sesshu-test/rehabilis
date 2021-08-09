require 'rails_helper'

RSpec.describe '検索', type: :system do
  let(:post) { create(:post) }

  it '検索アイコンを押すと検索ボックスが挿入され、✖︎アイコンを押すと検索ボックスが閉じる' do
    # 投稿一覧ページに遷移する
    visit root_path
    # 検索フォームはない
    expect(page).to have_no_selector 'form'
    # 検索アイコンをクリックする
    click_link '検索'
    # 検索フォームがある
    expect(page).to have_selector 'form'
    # ✖︎アイコンを押す
    click_link '閉じる'
    # 検索フォームがない
    expect(page).to have_no_selector 'form'
  end
  it '検索フォームでキーワード検索ができる' do
    # 投稿一覧ページに遷移する
    visit root_path
    # 検索アイコンをクリックする
    click_link '検索'
    # 検索フォームに投稿の感想を入力し、検索
    fill_in 'keyword', with: post.impression
    #find('input[name="commit"]').click
    click_button '検索'
    # 検索結果ページが表示される
    expect(current_path).to eq searches_path
  end
end