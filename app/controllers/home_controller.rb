class HomeController < ApplicationController

  def index
    @reviews = Review.search(params[:page])
  end

  def search
    @reviews = Review.search(params[:page], search: params[:search])
    render :index
  end
end
