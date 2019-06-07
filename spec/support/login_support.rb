module LoginSupport
  def sign_in(login_user)
    visit login_path
    fill_in "メールアドレス", with: login_user.email
    fill_in "パスワード", with: login_user.password
    click_button "ログインする"
  end
end

RSpec.configure do |config|
  config.include LoginSupport
end