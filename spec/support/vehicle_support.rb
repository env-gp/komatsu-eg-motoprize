module VehicleSupport
  def vehicle_registration
    click_link "車両一覧"
    click_link "新規登録"
    choose "スズキ"
    fill_in "車種", with: "バンバン200"
    fill_in "おすすめレビュー動画", with: "v=5PeCamvFw-s,v=FJ6NgWiEbAM"
    click_button "登録する"
  end
end

RSpec.configure do |config|
  config.include VehicleSupport
end