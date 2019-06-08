require 'rails_helper'

describe "レビュー管理機能", type: :system do
  let(:user1) { FactoryBot.create(:admin_user) }
  let(:user2) { FactoryBot.create(:user) }
  let!(:vehicle) { FactoryBot.create(:vehicle) }
    
  before do
    sign_in login_user
  end

  describe "レビュー投稿機能" do
    context 'ユーザー1でログインしているとき' do
      let(:login_user) { user1 }

      it "ユーザー１がレビューを新規投稿後、レビュー一覧、レビュー詳細、ホーム、車両詳細に表示されること" do
        review_post

        # ユーザ－１のレビュー一覧に表示されること。
        expect(page).to have_content "レビュー「ツーリングにもってこい」を登録しました。"
        expect(page).to have_content "ツーリングにもってこい"
        expect(page).to have_content "Rebel500"
        expect(page).to have_content Date.today.to_s(:db)

        # レビュー詳細に表示されること。
        click_link "ツーリングにもってこい"
        expect(page).to have_content "Rebel500"
        expect(page).to have_content "ツーリング・買い物・その他"
        expect(page).to have_content "ツーリングにもってこい"
        expect(page).to have_content "スタイルがかっこいい\n存在感がある"
        expect(page).to have_content Date.today.to_s(:db)

        # ホームに表示されること。
        click_link "ホーム"
        expect(page).to have_content "ツーリングにもってこい"
        expect(page).to have_content "Rebel500"
        expect(page).to have_content "スタイルがかっこいい 存在感がある"
        expect(page).to have_content user1.name + "・" + I18n.l(Date.today, format: :short)

        # 車両詳細に表示されること。
        click_link "車両一覧"
        click_link "Rebel500"
        expect(page).to have_content "ツーリングにもってこい"
        expect(page).to have_content "Rebel500"
        expect(page).to have_content "スタイルがかっこいい 存在感がある"
        expect(page).to have_content user1.name + "・" + I18n.l(Date.today, format: :short)
      end
    end

    context "ユーザー２がログインしているとき" do
      let(:login_user) { user2 }

      it "ホームにユーザー１のレビューが表示されること" do
        FactoryBot.create(:review, title: "ツーリングにもってこい", body: "スタイルがかっこいい\n存在感がある", user: user1)
        click_link "ホーム"
        expect(page).to have_content "ツーリングにもってこい"
        expect(page).to have_content "Rebel500"
        expect(page).to have_content "スタイルがかっこいい 存在感がある"
        expect(page).to have_content user1.name + "・" + I18n.l(Date.today, format: :short)
      end
  
      it "ユーザー１のレビューがレビュー一覧に表示されないこと" do
        FactoryBot.create(:review, title: "ツーリングにもってこい", user: user1)
        click_link "マイページ"
        click_link "投稿一覧"
        expect(page).to have_no_content "ツーリングにもってこい"
        expect(page).to have_no_content "Rebel500"
        expect(page).to have_no_content "ツーリング・買い物・その他"
        expect(page).to have_no_content Date.today.to_s(:db)
      end
    end
  end

  describe "レビュー編集機能" do
    context 'ユーザー1でログインしているとき' do
      let(:login_user) { user1 }

      it "ユーザー１がレビューを編集後、レビュー一覧、レビュー詳細、ホーム、車両詳細に表示さること" do
        review_post
        click_link "編集"
        uncheck "ツーリング"
        check "仕事用"
        fill_in "題名", with: "日本の道に最も適したバイク"
        fill_in "コメント", with: "オールマイティで存在感がある"
        click_button "レビューを投稿する"

        # ユーザ－１のレビュー一覧に表示されること。
        expect(page).to have_content "レビュー「日本の道に最も適したバイク」を更新しました。"
        expect(page).to have_content "日本の道に最も適したバイク"
        expect(page).to have_content "Rebel500"
        expect(page).to have_content Date.today.to_s(:db)


        # レビュー詳細に表示されること。
        click_link "日本の道に最も適したバイク"
        expect(page).to have_content "Rebel500"
        expect(page).to have_content "買い物・仕事用・その他"
        expect(page).to have_content "日本の道に最も適したバイク"
        expect(page).to have_content "オールマイティで存在感がある"
        expect(page).to have_content Date.today.to_s(:db)

        # ホームに表示されること。
        click_link "ホーム"
        expect(page).to have_content "日本の道に最も適したバイク"
        expect(page).to have_content "Rebel500"
        expect(page).to have_content "オールマイティで存在感がある"
        expect(page).to have_content user1.name + "・" + I18n.l(Date.today, format: :short)

        # 車両詳細に表示されること。
        click_link "車両一覧"
        click_link "Rebel500"
        expect(page).to have_content "日本の道に最も適したバイク"
        expect(page).to have_content "【Rebel500】"
        expect(page).to have_content "オールマイティで存在感がある"
        expect(page).to have_content user1.name + "・" + I18n.l(Date.today, format: :short)
      end
    end
  end

  describe "レビュー削除機能" do
    context 'ユーザー1でログインしているとき' do
      let(:login_user) { user1 }

      it "ユーザー１がレビューを削除後、レビュー一覧、ホーム、車両詳細に表示されないこと" do
        review_post
        click_link "ツーリングにもってこい"
        click_link "削除"
        page.accept_confirm

        # ユーザ－１のレビュー一覧に表示されないこと。
        expect(page).to have_content "レビュー「ツーリングにもってこい」を削除しました。"
        visit current_path
        expect(page).to have_no_content "ツーリングにもってこい"
        expect(page).to have_no_content "Rebel500"
        expect(page).to have_no_content Date.today.to_s(:db)

        # ホームに表示されること。
        click_link "ホーム"
        expect(page).to have_no_content "ツーリングにもってこい"
        expect(page).to have_no_content "Rebel500"
        expect(page).to have_no_content "スタイルがかっこいい 存在感がある"
        expect(page).to have_no_content user1.name + "・" + I18n.l(Date.today, format: :short)

        # 車両詳細に表示されること。
        click_link "車両一覧"
        click_link "Rebel500"
        expect(page).to have_no_content "ツーリングにもってこい"
        expect(page).to have_no_content "【Rebel500】"
        expect(page).to have_no_content "スタイルがかっこいい 存在感がある"
        expect(page).to have_no_content user1.name + "・" + I18n.l(Date.today, format: :short)
      end
    end
  end
end
