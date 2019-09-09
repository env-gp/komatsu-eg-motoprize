require 'rails_helper'

describe ReviewsController, type: :request do
  let!(:user) { FactoryBot.create(:admin_user) }
  let!(:vehicle) { FactoryBot.create(:vehicle) }
  let!(:vehicle2) { FactoryBot.create(:vehicle_second) }
  let(:headers){ { "HTTP_REFERER" => makers_url } }
  let!(:review1) { FactoryBot.create(:review, title: "ツーリングにもってこい", body: "スタイルがかっこいい\n存在感がある", user: user) }
  let!(:review2) { FactoryBot.create(:review_2, title: "バランスがかっこいい", body: "取り回しがよく足つき性が良好", user: user, vehicle: vehicle2) }

  before do
    get login_path
    post login_path, params: {
      session: {
        email: user.email,
        password: "test-password"
      }
    }
  end

  describe 'GET #index' do

    it 'リクエストが成功すること' do
      get reviews_path, params: { user_id: user.id }
      expect(response.status).to eq 200
    end

    it '一覧に題名が表示されていること' do
      get reviews_path, params: { user_id: user.id }
      expect(response.body).to include review1.title
      expect(response.body).to include review2.title
    end
  end

  describe 'GET #show' do
    context 'レビューが存在する場合' do
      it 'リクエストが成功すること' do
        get review_path(review1.id)
        expect(response.status).to eq 200
      end

      it '一覧に題名が表示されていること' do
        get review_path(review1.id)
        expect(response.body).to include review1.title
      end
    end

    context 'レビューが存在しない場合' do
      subject { -> { get review_path(99)  } }

      it { is_expected.to raise_error ActiveRecord::RecordNotFound }
    end
  end

  describe 'GET #new' do
    it 'リクエストが成功すること' do
      get new_review_path, params: { vehicle_id: vehicle.id }
      expect(response.status).to eq 200
    end
  end

  describe 'POST #create' do
    it "有効な場合、レビューが登録できること" do
      review_attributes = FactoryBot.attributes_for(:review)
      expect {
        post reviews_path, params: {
          vehicle_id: vehicle.id,
          review: review_attributes
        }
      }.to change(user.reviews, :count).by(1)
    end

    it "無効な場合、レビューが登録できないこと" do
      review_attributes = FactoryBot.attributes_for(:review, :without_body)
      expect {
        post reviews_path, params: { vehicle_id: vehicle.id, review: review_attributes}, headers: headers
      }.to_not change(user.reviews, :count)
    end
  end

  describe 'GET #edit' do
    it 'リクエストが成功すること' do
      get edit_review_path(review1.id)
      expect(response.status).to eq 200
    end

    it '一覧に題名が表示されていること' do
      get edit_review_path(review1.id)
      expect(response.body).to include review1.title
    end
  end

  describe 'PUT #update' do
    let(:takashi) { FactoryBot.create :takashi }

    context 'パラメータが妥当な場合' do
      it 'リクエストが成功すること' do
        put review_path review1, params: { review: FactoryBot.attributes_for(:review, title: '存在感がすごい') }
        expect(response.status).to eq 302
      end

      it '題名が更新されること' do
        expect do
          put review_path review1, params: { review: FactoryBot.attributes_for(:review, title: '存在感がすごい') }
        end.to change { Review.find(review1.id).title }.from('ツーリングにもってこい').to('存在感がすごい')
      end

      it 'リダイレクトすること' do
        put review_path review1, params: { review: FactoryBot.attributes_for(:review, title: '存在感がすごい') }
        expect(response).to redirect_to(reviews_path(user_id: user.id))
      end
    end

    context '下書きでパラメータが不正な場合' do
      it 'タイトルが空の場合、リクエストが成功すること' do
        put review_path review1, params: { commit: ReviewDecorator::STATUS[Review::STATUS_DRAFT],
                                            review: FactoryBot.attributes_for(:review, :without_title) }
        expect(response.status).to eq 302
      end

      it 'コメントが空の場合、リクエストが成功すること' do
        put review_path review1, params: { commit: ReviewDecorator::STATUS[Review::STATUS_DRAFT],
                                            review: FactoryBot.attributes_for(:review, :without_body) }
        expect(response.status).to eq 302
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:user) { FactoryBot.create :user }

    it 'リクエストが成功すること' do
      delete review_path review1
      expect(response.status).to eq 302
    end

    it 'レビューが削除されること' do
      expect do
        delete review_path review1
      end.to change(Review, :count).by(-1)
    end

    it 'レビュー一覧にリダイレクトすること' do
      delete review_path review1
      expect(response).to redirect_to(reviews_path(user_id: user.id))
    end
  end
end
