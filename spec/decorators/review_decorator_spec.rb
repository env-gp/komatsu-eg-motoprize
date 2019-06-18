require 'rails_helper'

RSpec.describe ReviewDecorator do
  context "#get_uses" do
    it "get_usesが適切な文字列を返すこと" do
      review = FactoryBot.build(:review)
      expect(decorate(review).get_uses).to eq('ツーリング・レース・通勤・その他')
    end
  end
end
