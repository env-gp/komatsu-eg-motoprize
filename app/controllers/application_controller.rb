class ApplicationController < ActionController::Base
  helper_method :current_user, :correct_user
  before_action :current_user
  before_action :login_required
  before_action :current_weather

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
    
  def sign_in(user)
    remember_token = User.new_remember_token
    cookies.permanent[:user_remember_token] = remember_token
    user.update!(remember_token: User.encrypt(remember_token))
    @current_user = user
  end

  def sign_out
    cookies.delete(:user_remember_token)
  end
  
  def current_weather
    if current_user&.prefecture_id.present?
      forecast = Weather::Forecast.new(current_user.prefecture_id)
      @weather_condition = forecast.weather_condition
    end
  end

end
