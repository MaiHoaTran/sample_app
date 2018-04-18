ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../config/environment", __dir__)
require "rails/test_help"

module ActiveSupport
  class TestCase
    fixtures :all

    def is_logged_in?
      !session[:user_id].nil?
    end
  end
end
