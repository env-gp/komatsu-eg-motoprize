require 'rails_helper'

describe "参考になった機能", type: :system do
  let!(:user1) { FactoryBot.create(:admin_user) }
  let!(:user2) { FactoryBot.create(:user) }
  let!(:review) { FactoryBot.create(:review, title: 'ツーリングにもってこい', user: user1) }

  before do
    sign_in login_user
  end

  context "参考になった投票機能" do
    let(:login_user) { user1 }

    it "ユーザー１、ユーザー２がレビューに「参考になった」をした場合、表示が切り替わること" do
      expect(page).to have_content "参考になった"
      click_link "参考になった"

      expect(page).to have_content "投票済み1"

      click_link "ログアウト"

      sign_in user2
      click_link "参考になった1"

      expect(page).to have_content "投票済み2"
      click_link "ログアウト"

      sign_in user1
      expect(page).to have_content "投票済み2"

      click_link "マイページ"
      expect(page).to have_content "#{user1.name}が#{review.title}に「参考になった」をしました"
      expect(page).to have_content "#{user2.name}が#{review.title}に「参考になった」をしました"

      click_link "車両一覧"
      click_link "Rebel500"
      expect(page).to have_content "投票済み2"
    end
  end

  context "参考になった投票取消機能" do
    let(:login_user) { user1 }

    it "ユーザー１、ユーザー２がレビューの「参考になった」を取り消した場合、表示が切り替わること" do
      click_link "参考になった"

      expect(page).to have_content "投票済み1"

      click_link "ログアウト"

      sign_in user2
      click_link "参考になった1"

      expect(page).to have_content "投票済み2"
      click_link "ログアウト"

      sign_in user1
      click_link "投票済み2"
      expect(page).to have_content "参考になった1"

      click_link "マイページ"
      expect(page).to have_no_content "#{user1.name}が#{review.title}に「参考になった」をしました"

      click_link "ログアウト"

      sign_in user2
      click_link "投票済み1"
      expect(page).to have_content "参考になった"

      click_link "車両一覧"
      click_link "Rebel500"
      expect(page).to have_content "参考になった"

    end
  end
end