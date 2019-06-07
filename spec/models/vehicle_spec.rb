require 'rails_helper'

RSpec.describe Vehicle, type: :model do

  context "必須チェック" do
    it "車名があれば有効な状態であること" do
      vehicle = FactoryBot.build(:vehicle)
      vehicle.valid?    
      expect(vehicle).to be_valid
    end

    it "nameがなければ無効な状態であること" do
      vehicle = FactoryBot.build(:vehicle, :without_vehicle_name)
      vehicle.valid?
    
      expect(vehicle.errors[:name]).to include("を入力してください")
    end
  end

  context "メーカー取得チェック" do
    it "メーカーが取得できること" do
      vehicle = FactoryBot.build(:vehicle)
    
      expect(vehicle.maker.name).to include("ホンダ")
    end
  end
end
