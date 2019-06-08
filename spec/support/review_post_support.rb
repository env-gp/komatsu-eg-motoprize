module ReviewPostSupport
  def review_post
    click_link "新規投稿"
    choose "ホンダ"
    click_button "検索"
    click_button "レビューを書く"

    check "ツーリング"
    check "買い物"
    check "その他"
    fill_in "題名", with: "ツーリングにもってこい"
    fill_in "コメント", with: "スタイルがかっこいい\n存在感がある"
    click_button "レビューを投稿する"
  end
end

RSpec.configure do |config|
  config.include ReviewPostSupport
end