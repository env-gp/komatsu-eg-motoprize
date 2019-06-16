class ApplicationController < ActionController::Base
  helper_method :current_user, :correct_user
  before_action :current_user
  before_action :login_required

  private

  def correct_user(user_id)
    if current_user.blank?
      false
    else
      @current_user.id == user_id
    end
  end

  def current_user
    remember_token = User.encrypt(cookies[:user_remember_token])
    @current_user ||= User.find_by(remember_token: remember_token)
  end

  def login_required
    redirect_to login_path unless @current_user.present?
  end
 
end
