require 'rails_helper'

RSpec.describe 'メッセージ', type: :system do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:message) { create(:message) }

  describe 'メッセージ送信' do
    it 'ログインしたユーザーは他人にメッセージを送信でき、受信側は通知一覧とDM一覧から確認できる' do
      test_message = 'テストメッセージ'
      # ログインする
      signIn(user)
      # メッセージを送る相手のユーザ詳細ページに遷移する
      visit user_path(other_user)
      # ボタンを押してチャットルームに遷移する
      click_button 'DM'
      expect(page).to have_field 'メッセージを入力して下さい'
      # メッセージを送信するとチャットルーム内に表示され、Messageモデルのカウントが１上がる
      fill_in 'メッセージを入力して下さい', with: test_message
      expect  do
        click_button '送信'
        expect(page).to have_content test_message
      end.to change {Message.count}.by(1)
      # DM一覧にて送信したメッセージが表示される
      visit rooms_path
      expect(page).to have_content test_message
      # ログアウトする
      click_link 'ログアウト'
      expect(current_path).to eq root_path
      # 受信側のユーザでログインする
      signIn(other_user)
      # 通知一覧に受信したメッセージが表示される
      visit notifications_path
      expect(page).to have_content test_message
      # DM一覧で受信したメッセージのリンクを踏むと、チャットールームに遷移する
      visit rooms_path
      click_link test_message
      expect(page).to have_content(test_message)
      expect(page).to have_field 'メッセージを入力して下さい'
    end
    it 'ログインしていないユーザは他人にメッセージを送信できない' do
      # メッセージを送る相手のユーザ詳細ページに遷移する
      visit user_path(other_user)
      # チャットルームへのリンクがない
      expect(page).to have_no_content('mail')
    end
  end

  describe 'メッセージ削除' do
    it '自分のメッセージは削除できる' do
      test_message = 'テストメッセージ'
      # ログインする
      signIn(user)
      # メッセージを送る相手のユーザ詳細ページに遷移する
      visit user_path(other_user)
      # ボタンを押してチャットルームに遷移する
      click_button 'DM'
      expect(page).to have_field 'メッセージを入力して下さい'
      # メッセージを送信するとチャットルーム内に表示され、Messageモデルのカウントが１上がる
      fill_in 'メッセージを入力して下さい', with: test_message
      expect  do
        click_button '送信'
        expect(page).to have_content test_message
      end.to change {Message.count}.by(1)
      # コメントを削除すると、Commentモデルのカウントが1下がる
      expect do
        accept_alert do
          click_button '削除'
        end
        sleep 1
      end.to change { Message.count }.by(-1)
    end
    it '他人のメッセージは削除できない' do
      test_message = 'テストメッセージ'
      # ログインする
      signIn(other_user)
      # メッセージを送る相手のユーザ詳細ページに遷移する
      visit user_path(user)
      # ボタンを押してチャットルームに遷移する
      click_button 'DM'
      expect(page).to have_field 'メッセージを入力して下さい'
      # メッセージを送信するとチャットルーム内に表示され、Messageモデルのカウントが１上がる
      fill_in 'メッセージを入力して下さい', with: test_message
      expect  do
        click_button '送信'
        expect(page).to have_content test_message
      end.to change {Message.count}.by(1)
      # ログアウトする
      click_link 'ログアウト'
      expect(current_path).to eq root_path
      # 受信側のユーザでログインする
      signIn(user)
      # DM一覧で受信したメッセージのリンクを踏むと、チャットールームに遷移する
      visit rooms_path
      click_link test_message
      expect(page).to have_no_button '削除'
    end
  end
  
end