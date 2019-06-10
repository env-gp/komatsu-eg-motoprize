class ReviewsController < ApplicationController

  skip_before_action :login_required, only: [:show, :index]

  include Admin_common

  before_action :set_review, only: [:show, :edit, :update, :destroy]
  before_action :correct_user_check, only: [:edit, :update, :destroy]
  
  def new
    @vehicle = Vehicle.find_by(id: params[:vehicle_id])
    @maker = Maker.find(@vehicle.maker_id)
    @path = Rails.application.routes.recognize_path(request.referer)

    error_message = Review.duplicate_review(@current_user.id, @vehicle.id)
    if error_message
      if @path[:controller] == "vehicles"
        redirect_to vehicle_path(@vehicle.id), alert: error_message 
      else
        redirect_to makers_path, alert: error_message
      end
    end
    @review = Review.new
  end

  def edit
    # 遷移元のcontroller,actionを取得
    @path = Rails.application.routes.recognize_path(request.referer)
  end

  def update
    if params[:image]
      @review.image.attach(params[:review][:image])
    end

    if @review.update(review_params)
      redirect_to index_reviews_path(current_user.id), notice: "レビュー「#{@review.title}」を更新しました。"
    else
      @path = Rails.application.routes.recognize_path(request.referer)
      render :edit
    end
  end

  def create
    @vehicle = Vehicle.find_by(id: params[:vehicle_id])
    @review = @current_user.reviews.new(review_params.merge(vehicle_id: @vehicle.id))

    if @review.save
      redirect_to index_reviews_path(current_user.id), notice: "レビュー「#{@review.title}」を登録しました。"
    else
      @path = Rails.application.routes.recognize_path(request.referer)
      render :new
    end
  end

  def destroy
    @review.image.purge if @review.image.attached?
    @review.destroy
    unless request.xhr?
      redirect_to index_reviews_path(current_user.id), notice: "レビュー「#{@review.title}」を削除しました。"
    end
  end

  def show
    # 遷移元のcontroller,actionを取得
    @path = Rails.application.routes.recognize_path(request.referer)
  end

  def index
    search_by_ransack
  end

  def index_reviews_path(user_id)
    "/reviews/#{user_id}/index"
  end

  private

  def set_review
    @review = Review.find(params[:id])
    @vehicle = Vehicle.find(@review.vehicle_id)
  end

  def review_params
    params.require(:review).permit(:title, :body, :image, :touring, :race, :shopping, :commute, :work, :etcetera)
  end

  def correct_user_check
    redirect_to root_path, notice: "権限がありません" unless @current_user.id == @review.user.id
  end

  def search_by_ransack
    @user = User.find_by(id: params[:user_id])
    @q = @user.reviews.includes(:vehicle).ransack(params[:q])
    @reviews = @q.result(distinct: true).page(params[:page]).per(Review::REVIEWLIST_PAGINATION_MAX)
  end

end
