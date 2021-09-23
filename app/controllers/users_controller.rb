class UsersController < ApplicationController
  before_action :set_user, only: [:show, :following, :followers, :myposts, :likes, :graph]
  before_action :join_room, only: :show

  def show
    @count_or_time = "count"
    get_rehabilitations_data(@count_or_time)
  end

  def index
    @users = User.all.page(params[:page])

    if user_signed_in? && user_have_at_least_one_ill?(current_user)
      @recommended_users = User.joins(:ills).includes(:ills).users_with_like_ill(current_user).where.not(id: current_user.id)
    end
  end

  def following
    @title = "Following"
    @users = @user.following.page(params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @users = @user.followers.page(params[:page])
    render 'show_follow'
  end

  def guest_sign_in
    user = User.find_or_create_by!(email: 'guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.confirmed_at = Time.now
      user.name = "ゲスト"
    end
    sign_in user
    redirect_to root_path, notice: 'ゲストユーザーとしてログインしました。'
  end

  def graph
    @count_or_time = params[:count_or_time]
    get_rehabilitations_data(@count_or_time)
    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path) }
      format.js
    end
  end

  def myposts
    @myposts = @user.posts.page(params[:page])
    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path) }
      format.js
    end
  end

  def likes
    likes = Like.where(user_id: @user.id).order(created_at: :desc).pluck(:post_id)
    @liking_posts = Post.includes(:user).find(likes)
    @liking_posts = Kaminari.paginate_array(@liking_posts).page(params[:page])
    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path) }
      format.js
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def join_room
    if user_signed_in?
      unless @user.id == current_user.id
        # Entryモデルからロレコードを抽出
        @current_entry = Entry.where(user_id: current_user.id)
        @another_entry = Entry.where(user_id: @user.id)
        @current_entry.each do |current|
          @another_entry.each do |another|
            # ルームが存在する場合
            if current.room_id == another.room_id
              @is_room = true
              @room_id = current.room_id
            end
          end
        end
        # ルームが存在しない場合は新規作成
        unless @is_room
          @room = Room.new
          @entry = Entry.new
        end
      end
    end
  end

  def get_rehabilitations_data(count_or_time)
    #本人のリハビリ情報の取得し、rehabilitationsに格納
    rehabilitations = Rehabilitation.includes(post: :user).where(user: {id:  @user.id}).where("#{count_or_time} > 0").order(created_at: :asc)
    if rehabilitations.presence
      #rehabilitationsをグラフに適したデータ構造に変更し、折れ線や円のchart_dataに格納する
      @line_chart_data = []
      @pie_chart_data = []
      i = 0
      rehabilitations.group_by { |rehabilitation| [rehabilitation[:name]] }.each do |grouped_reha|
        @line_chart_data[i] = {}
        #リハビリの名称を格納
        @line_chart_data[i][:name] = grouped_reha[0][0]
        @line_chart_data[i][:data] = []
        @pie_chart_data[i] = []
        #リハビリの合計回数を格納する変数
        count_sum = 0
        grouped_reha[1].each do |content_reha|
          count_sum += content_reha.send(count_or_time)
          #最新のリハビリ情報を格納
          lastdata = @line_chart_data[i][:data].last
          #Timestampを文字列にし、日付のみの情報に変更
          date_string = content_reha.created_at.to_s.slice(0..9)
          #初めてのリハビリではなく、かつ、同日にそのリハビリを行っているのであれば
          if lastdata.presence && date_string == lastdata[0]
            #その日のリハビリ回数を更新
            @line_chart_data[i][:data].last[1] += content_reha.send(count_or_time)
          else
            #リハビリの日付・回数を格納
            @line_chart_data[i][:data].push([date_string, content_reha.send(count_or_time)])
          end
        end
        #リハビリの名称と合計回数を格納
        @pie_chart_data[i].push(grouped_reha[0][0], count_sum)
        i += 1
      end
    end
  end

  def user_have_at_least_one_ill?(user)
    if user.ills.present?
      user.ills[0].name.present? || user.ills[1].name.present? || user.ills[2].name.present?
    end
  end

end
