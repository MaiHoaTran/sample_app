class PasswordResetsController < ApplicationController
  before_action :find_user, only: %i(edit update)
  before_action :valid_user, only: %i(edit update)
  before_action :check_expiration, only: %i(edit update)

  def new; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "password_resets.new.infor_msg"
      redirect_to root_url
    else
      flash.now[:danger] = t "password_resets.new.danger_msg"
      render :new
    end
  end

  def edit; end

  def update
    if params[:user][:password].empty?
      @user.errors.add :password, t("password_resets.new.password_not_empty")
      render :edit
    elsif @user.update user_params
      log_in @user
      flash[:success] = t "password_resets.edit.success_msg"
      redirect_to @user
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def find_user
    @user = User.find_by email: params[:email]
    return if @user.present?
    flash[:danger] = t "static_pages.home.not_find_user"
    redirect_to root_url
  end

  def valid_user
    return if @user && @user.activated? && @user.authenticated?(:reset, params[:id])
    redirect_to root_url
  end

  def check_expiration
    return unless @user.password_reset_expired?
    flash[:danger] = t "password_resets.edit.danger_msg"
    redirect_to new_password_reset_url
  end
end
