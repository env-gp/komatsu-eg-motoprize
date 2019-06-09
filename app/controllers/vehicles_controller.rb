class VehiclesController < ApplicationController

  include Admin_common
  before_action :require_admin, except: [:index, :show]

  before_action :set_vehicle, {only: [:show, :edit, :update, :destroy]}
  
  def index
    @vehicles = Vehicle.all.name_order_asc
  end

  def new
    @vehicle = Vehicle.new
    @makers = Maker.all.order_asc
  end

  def show
    @maker = Maker.find(@vehicle.maker_id)
    @reviews = Review.search(params[:page], vehicle_id: @vehicle.id)
  end

  def edit
    @makers = Maker.all.order_asc
  end

  def create
    @vehicle = Vehicle.new(vehicle_params)

    if @vehicle.save
      @vehicle.reload
      
      save_image

      redirect_to vehicles_path, notice: "「#{@vehicle.name}」を登録しました。"
    else
      @makers = Maker.all.order_asc
      flash[:notice] = "「#{@vehicle.name}」を登録できませんでした。"
      render :new
    end
  end

  def update
    save_image

    if @vehicle.update(vehicle_params)
      redirect_to vehicle_path(@vehicle), notice: "「#{@vehicle.name}」を更新しました。"
    else
      flash[:notice] = "「#{@vehicle.name}」を更新できませんでした。"
      render :new
    end
  end

  def destroy
    # 既に投稿されていた場合、削除できない
    if @vehicle.destroy
      image_name = "#{@vehicle.id}.jpg"
      begin
        FileUtils.rm("app/assets/images/vehicles/#{image_name}")
      rescue => e
        puts "画像ファイルの削除に失敗しました : " + e.message
        raise
      end
      redirect_to vehicles_url, notice: "「#{@vehicle.name}」を削除しました。"
    else
      redirect_to vehicles_url, alert: "「#{@vehicle.name}」を削除できませんでした。既に投稿されています。"
    end
  end

  private

  def vehicle_params
    params.require(:vehicle).permit(:name, :maker_id, :movie)
  end

  def set_vehicle
    @vehicle = Vehicle.find(params[:id])
  end

  def fileupload_param
    params.require(:fileupload).permit(:file)
  end

  def save_image
    if params[:fileupload] && fileupload_param[:file]
      uploaded_file = fileupload_param[:file]
      image_name = "#{@vehicle.id}.jpg"
      begin
        File.binwrite("app/assets/images/vehicles/#{image_name}", uploaded_file.read)
      rescue => e
        puts "画像ファイルの保存に失敗しました : " + e.message
        raise
      end
    end
  end

end
