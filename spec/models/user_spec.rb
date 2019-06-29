require 'rails_helper'

RSpec.describe User, type: :model do

  context "必須チェック" do
    it "名、メール、パスワードがあれば有効な状態であること" do
      user = FactoryBot.build(:user)
  
      expect(user).to be_valid
    end

    it "nameがなければ無効な状態であること" do
      user = FactoryBot.build(:user, :without_user_name)
      user.valid?

      expect(user.errors[:name]).to include("を入力してください")
    end

    it "emailがなければ無効な状態であること" do
      user = FactoryBot.build(:user, :without_user_email)
      user.valid?

      expect(user.errors[:email]).to include("を入力してください")
    end

    it "emailがなければ無効な状態であること 意図した英語の値が返る" do
      user = FactoryBot.build(:user, :without_user_email)

      I18n.with_locale(:en) do
        user.valid?
        expect(user.errors[:email]).to include("can't be blank")
      end
    end
  end

  context "入力値チェック" do
    it "重複したメールアドレスなら無効な状態であること" do
      FactoryBot.create(:user, email: "double@example.com")
      user = FactoryBot.build(:user, email: "double@example.com")
      user.valid?

      expect(user.errors[:email]).to include("はすでに存在します")
    end

    it "emailのフォーマットが正しくなければ無効な状態であること" do
      user = FactoryBot.build(:user, email: "testerexamle.com") 
      user.valid?

      expect(user.errors[:email]).to include("は不正な値です")
    end
  end

  context "関連ＤＢが削除されること" do
    it "userを削除すると、userが書いたreview, like(参考になった)も削除されること" do
      user = FactoryBot.create(:user)
      review = FactoryBot.create(:review, user: user)
      Like.create(user_id: user.id, review_id: review.id)

      expect{ user.destroy }.to change{ Review.count }.by(-1).and change{ Like.count }.by(-1)
    end
  end

  context "Active Storage" do

    after do
      @user.avatar.purge
    end

    it "アバター画像が登録できること" do
      @user = FactoryBot.create(:user)
      @user.avatar.attach(io: File.open(Rails.root.join('spec', 'factories', 'images', 'test.jpg').to_s), filename: 'test.jpg', content_type: 'image/jpg')
      expect(@user.avatar.attached?).to be true
    end
  
    it "アバター画像が更新できること" do
      @user = FactoryBot.create(:user)
      @user.avatar.attach(io: File.open(Rails.root.join('spec', 'factories', 'images', 'test.jpg').to_s), filename: 'test.jpg', content_type: 'image/jpg')
      expect(@user.avatar.attached?).to be true
    end
  
    it "アバター画像が削除できること" do
      @user = FactoryBot.create(:user)
      @user.avatar.attach(io: File.open(Rails.root.join('spec', 'factories', 'images', 'test.jpg').to_s), filename: 'test.jpg', content_type: 'image/jpg')
      @user.avatar.purge
      expect(@user.avatar.attached?).to be false
    end
  end
end