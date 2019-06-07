require 'rails_helper'

RSpec.describe Maker, type: :model do

  context "必須チェック" do
    it "題名とレビューコメントがあれば有効な状態であること" do
      vehicle = FactoryBot.build(:vehicle)
      vehicle.valid?    
      expect(vehicle).to be_valid
    end

    it "nameがなければ無効な状態であること" do
      maker = FactoryBot.build(:maker, :without_maker_name)
      maker.valid?
    
      expect(maker.errors[:name]).to include("を入力してください")
    end

    it "orderがなければ無効な状態であること" do
      maker = FactoryBot.build(:maker, :without_maker_order)
      maker.valid?
    
      expect(maker.errors[:order]).to include("を入力してください")
    end
  end
end
