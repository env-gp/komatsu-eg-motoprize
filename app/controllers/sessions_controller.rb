class SessionsController < ApplicationController

  skip_before_action :login_required
  skip_before_action :current_weather

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
end
