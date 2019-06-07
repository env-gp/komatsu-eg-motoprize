class MakersController < ApplicationController
  def index
    @makers = Maker.all.order(order: "ASC")
  end

  def vehicle_form
    @vehicles = Vehicle.where(maker_id: params[:maker_id]).order(name: "ASC")
  end

end
