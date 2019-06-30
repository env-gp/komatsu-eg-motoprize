require 'rails_helper'

describe "車両管理機能", type: :system do
  let(:user1) { FactoryBot.create(:admin_user) }
  let!(:maker) { FactoryBot.create(:maker) }
  let!(:maker_suzuki) { FactoryBot.create(:maker_suzuki) }
  let!(:maker_yamaha) { FactoryBot.create(:maker_yamaha) }

  before do
    sign_in login_user
  end

  context "車両登録機能" do
    let(:login_user) { user1 }

    it '車両登録後、車両一覧に表示されること' do
      vehicle_registration

      click_link "車両一覧"
      expect(page).to have_content "バンバン200"
      expect(page).to have_content "スズキ"
    end

    it '車両登録後、更新できること' do
      vehicle_registration

      expect(page).to have_content "バンバン200"
      expect(page).to have_content "スズキ"

      click_link "編集"
      choose "ヤマハ"
      fill_in "車種", with: "バンバンバン400"
      click_button "登録する"
      click_link "車両一覧"
      expect(page).to have_content "バンバンバン400"
      expect(page).to have_content "ヤマハ"
    end

    it '車両登録後、削除できること' do
      vehicle_registration

      expect(page).to have_content "バンバン200"
      expect(page).to have_content "スズキ"

      click_link "削除"
      page.accept_confirm
      click_link "車両一覧"
      expect(page).to_not have_content "バンバン200"
      expect(page).to_not have_content "スズキ"
    end
  end
end