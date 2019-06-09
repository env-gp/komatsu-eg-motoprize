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

      before do
        review_post
      end

      shared_examples '課題, コメント, 車両名、登録日時を検証' do
        it { expect(page).to have_content "ツーリングにもってこい" }
        it { expect(page).to have_content "【Rebel500】" }
        it { expect(page).to have_content "スタイルがかっこいい 存在感がある" }
        it { expect(page).to have_content user1.name + "・" + I18n.l(Date.today, format: :short) }
      end

      context "ユーザー１がレビューを新規投稿後、レビュー一覧、レビュー詳細、ホーム、車両詳細に表示されること" do

        it 'レビューを新規登録後、レビュー一覧に表示に表示されること' do
          expect(page).to have_content "レビュー「ツーリングにもってこい」を登録しました。"
          expect(page).to have_content "ツーリングにもってこい"
          expect(page).to have_content "Rebel500"
          expect(page).to have_content Date.today.to_s(:db)
        end

        it 'レビューを新規登録後、レビュー詳細に表示に表示されること' do
          click_link "ツーリングにもってこい"
          expect(page).to have_content "Rebel500"
          expect(page).to have_content "ツーリング・買い物・その他"
          expect(page).to have_content "ツーリングにもってこい"
          expect(page).to have_content "スタイルがかっこいい\n存在感がある"
          expect(page).to have_content Date.today.to_s(:db)
        end

        # ホームに表示されること。
        context 'レビューを新規登録後、ホームに表示に表示されること' do
          before do
            click_link "ホーム"
          end
          it_behaves_like '課題, コメント, 車両名、登録日時を検証'
        end

        context 'レビューを新規登録後、車両詳細に表示に表示されること' do
          before do
            click_link "車両一覧"
            click_link "Rebel500"
          end
          it_behaves_like '課題, コメント, 車両名、登録日時を検証'
        end
      end
    end

    context "ユーザー２がログインしているとき" do
      let(:login_user) { user2 }

      it "ホームにユーザー１のレビューが表示されること" do
        FactoryBot.create(:review, title: "ツーリングにもってこい", body: "スタイルがかっこいい\n存在感がある", user: user1)
        click_link "ホーム"
        expect(page).to have_content "ツーリングにもってこい"
        expect(page).to have_content "【Rebel500】"
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
    context 'レビューを更新後、各画面に表示されること' do
      let(:login_user) { user1 }

      before do
        review_post
        click_link "編集"
        uncheck "ツーリング"
        check "仕事用"
        fill_in "題名", with: "日本の道に最も適したバイク"
        fill_in "コメント", with: "オールマイティで存在感がある"
        click_button "レビューを投稿する"
      end

      shared_examples '課題, コメント, 車両名、登録日時を検証' do
        it { expect(page).to have_content "日本の道に最も適したバイク" }
        it { expect(page).to have_content "【Rebel500】" }
        it { expect(page).to have_content "オールマイティで存在感がある" }
        it { expect(page).to have_content user1.name + "・" + I18n.l(Date.today, format: :short) }
      end

      it "レビューを編集後、レビュー一覧に表示されること" do

        # ユーザ－１のレビュー一覧に表示されること。
        expect(page).to have_content "レビュー「日本の道に最も適したバイク」を更新しました。"
        expect(page).to have_content "日本の道に最も適したバイク"
        expect(page).to have_content "Rebel500"
        expect(page).to have_content Date.today.to_s(:db)
      end

      it "レビューを削除後、レビュー一覧に表示されないこと" do
        # レビュー詳細に表示されること。
        click_link "日本の道に最も適したバイク"
        expect(page).to have_content "Rebel500"
        expect(page).to have_content "買い物・仕事用・その他"
        expect(page).to have_content "日本の道に最も適したバイク"
        expect(page).to have_content "オールマイティで存在感がある"
        expect(page).to have_content Date.today.to_s(:db)
      end

        context 'レビューを編集後、ホームに表示に表示されること' do
          before do
            click_link "ホーム"
          end
          it_behaves_like '課題, コメント, 車両名、登録日時を検証'
        end

        context 'レビューを編集後、車両詳細にされること' do
          before do
            click_link "車両一覧"
            click_link "Rebel500"
          end
          it_behaves_like '課題, コメント, 車両名、登録日時を検証'
        end
      end
    end
  end

  describe "レビュー削除機能" do
    context 'レビューを削除後、各画面に表示されないこと' do
      let(:login_user) { user1 }

      before do
        review_post
        click_link "ツーリングにもってこい"
        click_link "削除"
        page.accept_confirm
      end

      shared_examples '課題, コメント, 車両名、登録日時を検証' do
        it { expect(page).to have_no_content "ツーリングにもってこい" }
        it { expect(page).to have_no_content "スタイルがかっこいい 存在感がある" }
        it { expect(page).to have_no_content "【Rebel500】" }
        it { expect(page).to have_no_content user1.name + "・" + I18n.l(Date.today, format: :short) }
      end

      it "レビューを削除後、レビュー一覧に表示されないこと" do
        expect(page).to have_content "レビュー「ツーリングにもってこい」を削除しました。"
        visit current_path
        expect(page).to have_no_content "ツーリングにもってこい"
        expect(page).to have_no_content "Rebel500"
        expect(page).to have_no_content Date.today.to_s(:db)
      end

      context 'レビューを削除後、ホームに表示されないこと' do
        before do
          click_link "ホーム"
        end
        it_behaves_like '課題, コメント, 車両名、登録日時を検証'
      end

      context 'レビューを削除後、車両詳細に表示されないこと' do
        before do
          click_link "車両一覧"
          click_link "Rebel500"
        end
        it_behaves_like '課題, コメント, 車両名、登録日時を検証'
      end
    end
  end
end
