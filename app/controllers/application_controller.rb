class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_time_zone

  private

  def set_time_zone
    Time.zone = "Asia/Bangkok"
  end
end
