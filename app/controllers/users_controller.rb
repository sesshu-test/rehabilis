class UsersController < ApplicationController
  before_action :set_user, only: [:show, :following, :followers]
  before_action :join_room, only: :show

  def show
    likes = Like.where(user_id: @user.id).order(created_at: :desc).pluck(:post_id)
    @likes = Post.find(likes)
    get_rehabilitations_data("time")    
  end

  def index
    @users = User.all.page(params[:page])
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
    #本人のリハビリ情報の取得し、@rehabilisに格納
    rehabilitations = Rehabilitation.includes(post: :user).where("#{count_or_time} > 0", user: {name: @user.name}).order(created_at: :asc)
    if rehabilitations.presence
      #@rehabilisをグラフに適したデータ構造に変更し、折れ線や円のchart_dataに格納する
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

end
