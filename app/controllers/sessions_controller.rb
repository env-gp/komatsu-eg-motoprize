class SessionsController < ApplicationController

  skip_before_action :login_required

  def new
  end

  def create
    user = User.find_by(email: session_params[:email])

    if user&.authenticate(session_params[:password])
      sign_in(user)
      redirect_to root_path, notice: 'ログインしました。'
    else
      @error_message = "メールアドレスまたはパスワードが間違っています"
      @email = session_params[:email]
      @password = session_params[:password]
      render :new
    end
  end

  def destroy
    sign_out
    redirect_to root_path, notice: 'ログアウトしました。'
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
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
end
