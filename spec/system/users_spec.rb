require 'rails_helper'

RSpec.describe User, type: :system do
  let(:user) { build(:user) }
  let(:other_user) { create(:user) }

  describe 'User CRUD' do
    describe 'ログイン前' do
      describe 'ユーザー新規登録' do
        context 'フォームの入力値が正常' do
          it 'ユーザーの新規作成が成功' do
            # ユーザー新規登録画面へ移動する
            visit new_user_registration_path
            # ユーザー情報を入力する
            fill_in 'Name', with: user.name
            fill_in 'Email', with: user.email
            fill_in 'Password', with: user.password
            fill_in 'Password confirmation', with: user.password
            # 新規登録ボタンを押すとUserモデルのカウントが1上がる
            expect  do
              click_button 'Sign up'
            end.to change { User.count }.by(1)
          end
        end
        context 'メールアドレス未記入' do
          it 'ユーザーの新規作成が失敗' do
            # ユーザー新規登録画面へ遷移
            visit new_user_registration_path
            # ユーザー情報を入力する
            fill_in 'Name', with: user.name
            fill_in 'Email', with: nil
            fill_in 'Password', with: user.password
            fill_in 'Password confirmation', with: user.password
            # 新規登録ボタンを押してもUserモデルのカウントは上がらない
            expect  do
              click_button 'Sign up'
            end.to change { User.count }.by(0)
            # /usersへ移動する
            expect(current_path).to eq '/users'
            # 遷移されたページに'Email can't be blank'の文字列がある
            expect(page).to have_content "Email can't be blank"
          end
        end
        context '登録済メールアドレス' do
          it 'ユーザーの新規作成が失敗' do
            # ユーザー新規登録画面へ遷移
            visit new_user_registration_path
            # ユーザー情報を入力する
            fill_in 'Name', with: user.name
            fill_in 'Email', with: other_user.email
            fill_in 'Password', with: other_user.password
            fill_in 'Password confirmation', with: other_user.password
            # 新規登録ボタンを押してもUserモデルのカウントは上がらない
            expect  do
              click_button 'Sign up'
            end.to change { User.count }.by(0)
            # /usersへ移動する
            expect(current_path).to eq '/users'
            # 遷移されたページに'Email has already been taken'の文字列がある
            expect(page).to have_content "Email has already been taken"
          end
        end
      end
    end
    describe 'ログイン後' do
      before { signIn(other_user) }
      describe 'ユーザー編集' do
        context 'フォームの入力値が正常' do
          it 'ユーザーの編集が成功' do
            visit edit_user_registration_path
            fill_in 'Name', with: 'テスト'
            fill_in 'Email', with: 'test@gmail.com'
            fill_in 'Password', with: 'testTest'
            fill_in 'Password confirmation', with: 'testTest'
            fill_in 'Current password', with: other_user.password
            fill_in 'ill-1', with: '靭帯損傷'
            fill_in 'Introduction', with: 'よろしくお願いします。'
            click_button 'Update'
            expect(current_path).to eq root_path
          end
        end
        context '現在のパスワードが未入力' do
          it 'ユーザーの編集が失敗' do
            visit edit_user_registration_path
            fill_in 'Name', with: 'テスト'
            fill_in 'Email', with: 'test@gmail.com'
            fill_in 'Password', with: 'testTest'
            fill_in 'Password confirmation', with: 'testTest'
            fill_in 'Current password', with: nil
            fill_in 'ill-1', with: '靭帯損傷'
            fill_in 'Introduction', with: 'よろしくお願いします。'
            click_button 'Update'
            # /usersへ移動する
            expect(current_path).to eq '/users'
          end
        end
      end
    end
  end
end