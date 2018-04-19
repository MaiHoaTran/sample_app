class UsersController < ApplicationController
  before_action :load_user, only: %i(edit update show correct_user following followers)
  before_action :logged_in_user, only: %i(index edit update destroy show following followers)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def index
    @users = User.paginate page: params[:page], per_page: Settings.user.number_items_per_page
  end

  def destroy
    if User.find_by(id: params[:id]).destroy
      flash[:success] = I18n.t "users.index.success_msg"
    else
      flash[:danger] = I18n.t "users.index.error_msg"
    end
    redirect_to users_url
  end

  def show
    if @user.blank?
      redirect_to signup_path
    else
      @microposts = @user.microposts.paginate page: params[:page], per_page: Settings.user.number_items_per_page
      render :show
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = I18n.t "users.new.info_activation"
      redirect_to root_url
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = I18n.t "users.edit.success_msg"
      redirect_to @user
    else
      render :edit
    end
  end

  def following
    @title = I18n.t "users.show_follow.following"
    @users = @user.following.paginate page: params[:page], per_page: Settings.user.number_items_per_page
    render :show_follow
  end

  def followers
    @title = I18n.t "users.show_follow.followers"
    @users = @user.followers.paginate page: params[:page], per_page: Settings.user.number_items_per_page
    render :show_follow
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def correct_user
    redirect_to root_url unless current_user? @user
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end

  def load_user
    @user = User.find_by id: params[:id]
  end
end
