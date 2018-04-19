class UsersController < ApplicationController
  before_action :load_user, except: %i(index new create)
  before_action :logged_in_user, except: %i(new create)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def index
    @users = User.paginate page: params[:page], per_page: Settings.user.number_items_per_page
  end

  def destroy
    if @user.destroy
      flash[:success] = t "users.index.success_msg"
    else
      flash[:danger] = t "users.index.error_msg"
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
      flash[:info] = t "users.new.infor_activation"
      redirect_to root_url
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t "users.edit.success_msg"
      redirect_to @user
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password, :password_confirmation
  end

  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t "message_not_login"
    redirect_to login_url
  end

  def correct_user
    redirect_to root_url unless current_user? @user
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user.present?
    flash[:danger] = t "static_pages.home.not_find_user"
    redirect_to root_url
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end
end
