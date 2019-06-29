class ReviewsController < ApplicationController

  skip_before_action :login_required, only: [:show, :index, :drafts_index, :gallerys_index]

  include AdminCommon

  before_action :set_review, only: [:show, :edit, :update, :destroy]
  before_action :correct_user_check, only: [:drafts_index, :edit, :update, :destroy]
  
  def new
    @vehicle = Vehicle.find_by(id: params[:vehicle_id])
    @maker = Maker.find(@vehicle.maker_id)
    before_controller

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
    before_controller
  end

  def update
    @review.assign_attributes(review_params)

    ApplicationRecord.transaction do
      if review_params[:image]
        @review.image.attach(params[:review][:image])
      end
    
      if params[:image_delete] && @review.image.attached?
        @review.image.purge
      end

      if execute_save
        screen_migration('更新')
      else
        before_controller
        render :edit
      end
    end
  end

  def create
    @vehicle = Vehicle.find_by(id: params[:vehicle_id])
    @review = @current_user.reviews.new(review_params.merge(vehicle_id: @vehicle.id))

    if execute_save
      screen_migration('登録')
    else
      before_controller
      render :new
    end
  end

  def destroy
    ApplicationRecord.transaction do
      @review.image.purge if @review.image.attached?
      @review.destroy!
    end

    unless request.xhr?
      if @review.status == Review::STATUS_PUBLISH
        redirect_to reviews_path(user_id: current_user.id), notice: "レビュー「#{@review.title}」を削除しました。"
      else
        redirect_to drafts_index_path(user_id: current_user.id), notice: "レビュー「#{@review.title}」を削除しました。"
      end
    end
  end

  def show
    # 遷移元のcontroller,actionを取得
    before_controller
  end

  def drafts_index
    search_by_ransack(Review::STATUS_DRAFT)
  end

  def index
    search_by_ransack(Review::STATUS_PUBLISH)
  end

  def gallerys_index
    @reviews = Review.search(params[:page], mode: 'gallerys')
  end

  private

  def set_review
    @review = Review.find(params[:id])
    @vehicle = Vehicle.find(@review.vehicle_id)
  end

  def review_params
    params.require(:review).permit(:title, :body, :image, :touring, :race, :shopping, :commute, :work, :etcetera)
  end

  def search_by_ransack(status)
    @user = User.find_by(id: params[:user_id])
    @q = @user.reviews.includes(:vehicle).where(status: status).ransack(params[:q])
    @reviews = @q.result(distinct: true).page(params[:page]).per(Review::REVIEWLIST_PAGINATION_MAX)
  end

  def execute_save
    if status_judgment
      @review.status = Review::STATUS_DRAFT
      @review.save!
    else
      @review.status = Review::STATUS_PUBLISH
      @review.save(context: :publish)
    end
  end

  def status_judgment
    params[:commit] == ReviewDecorator::STATUS[Review::STATUS_DRAFT]
  end

  def correct_user_check
    user_id = params[:user_id].to_i
    unless @review.nil?
      user_id = @review.user.id
    end

    redirect_to root_path, notice: "権限がありません" unless @current_user.id == user_id
  end

  def screen_migration(mode)
    flash[:notice] = "レビュー「#{@review.title}」を#{mode}しました。"

    if status_judgment
      redirect_to drafts_index_path(user_id: current_user.id)
    else
      redirect_to reviews_path(user_id: current_user.id)
    end
  end

  def before_controller
    @path = Rails.application.routes.recognize_path(request.referer)
  end
end
