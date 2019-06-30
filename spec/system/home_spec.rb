require 'rails_helper'

describe "ホーム機能", type: :system do
  let(:user1) { FactoryBot.create(:admin_user) }
  let(:user2) { FactoryBot.create(:user) }
  let(:vehicle1) { FactoryBot.create(:vehicle) }
  let(:vehicle2) { FactoryBot.create(:vehicle_second, maker: vehicle1.maker) }
  let!(:review1) { FactoryBot.create(:review, title: "ツーリングにもってこい", body: "スタイルがかっこいい\n存在感がある", user: user1) }
  let!(:review2) { FactoryBot.create(:review_2, title: "バランスがかっこいい", body: "取り回しがよく足つき性が良好", user: user2, vehicle: vehicle2) }
  
  before do
    sign_in login_user
  end

  describe "ホーム一覧機能" do

    context 'ユーザー1でログインしているとき' do
      let(:login_user) { user1 }

      it "ユーザー１とユーザー２のレビューが一覧表示されること" do
        click_link "ホーム"

        expect(page).to have_content "#{user1.name.truncate(20)}・#{I18n.l(review1.created_at, format: :short)}"
        expect(page).to have_content "ツーリングにもってこい"
        expect(page).to have_content "Rebel500"
        expect(page).to have_content "スタイルがかっこいい 存在感がある"

        expect(page).to have_content "#{user2.name.truncate(20)}・#{I18n.l(review2.created_at, format: :short)}"
        expect(page).to have_content "バランスがかっこいい"
        expect(page).to have_content "CB400SF"
        expect(page).to have_content "取り回しがよく足つき性が良好"
      end
    end
  end

  describe "ホーム検索機能" do
    context 'ユーザー1でログインしているとき' do
      let(:login_user) { user1 }

      it "ユーザー１のレビュータイトルで検索した場合、ユーザー２のレビューは表示されないこと" do
        click_link "ホーム"
        fill_in 'search', with: 'ツーリングにもってこい'
        click_button "検索"

        expect(page).to have_content "#{user1.name.truncate(20)}・#{I18n.l(review1.created_at, format: :short)}"
        expect(page).to have_content "ツーリングにもってこい"
        expect(page).to have_content "Rebel500"
        expect(page).to have_content "スタイルがかっこいい 存在感がある"

        expect(page).to_not have_content "#{user2.name.truncate(20)}・#{I18n.l(review2.created_at, format: :short)}"
        expect(page).to_not have_content "バランスがかっこいい"
        expect(page).to_not have_content "CB400SF"
        expect(page).to_not have_content "取り回しがよく足つき性が良好"
      end

      it "存在しないレビュータイトルで検索した場合、定型メッセージが表示されること" do
        click_link "ホーム"
        fill_in 'search', with: '足つき性がよく女性でも扱いやすい'
        click_button "検索"
        
        expect(page).to have_content "レビュー投稿はありません。"
        expect(page).to_not have_content "#{user1.name.truncate(20)}・#{I18n.l(review1.created_at, format: :short)}"
        expect(page).to_not have_content "ツーリングにもってこい"
        expect(page).to_not have_content vehicle1.name
        expect(page).to_not have_content "スタイルがかっこいい 存在感がある"
        
        expect(page).to_not have_content "#{user2.name.truncate(20)}・#{I18n.l(review2.created_at, format: :short)}"
        expect(page).to_not have_content "バランスがかっこいい"
        expect(page).to_not have_content vehicle2.name
        expect(page).to_not have_content "取り回しがよく足つき性が良好"
      end
    end
  end
end