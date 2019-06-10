class HomeController < ApplicationController

  skip_before_action :login_required

  def index
    @reviews = Review.search(params[:page])
  end

  def search
    @reviews = Review.search(params[:page], search: params[:search])
    render :index
  end
end
