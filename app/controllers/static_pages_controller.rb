class StaticPagesController < ApplicationController
  def home
    return unless logged_in?
    @micropost  = current_user.microposts.build
    @feed_items = current_user.feed.paginate page: params[:page], per_page: Settings.user.number_items_per_page
  end

  def help; end

  def contact; end

  def about; end
end
