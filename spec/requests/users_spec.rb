require 'rails_helper'

describe UsersController, type: :request do
  context 'パラメータが妥当な場合' do
    it 'リクエストが成功すること' do
      post users_url, params: { user: FactoryBot.attributes_for(:admin_user) }
      expect(response.status).to eq 302
    end

    it '有効の場合、ユーザーが登録されること' do
      expect do
        post users_url, params: { user: FactoryBot.attributes_for(:admin_user) }
      end.to change(User, :count).by(1)
    end

    it 'リダイレクトすること' do
      post users_url, params: { user: FactoryBot.attributes_for(:admin_user) }
      expect(response).to redirect_to root_path
    end
  end

  context 'パラメータが不正な場合' do
    it '無効の場合、ユーザーが登録されないこと' do
      expect do
        post users_url, params: { user: FactoryBot.attributes_for(:admin_user, :without_user_name) }
      end.to_not change(User, :count)
    end

    it '無効の場合、エラーが表示されること' do
      post users_url, params: { user: FactoryBot.attributes_for(:admin_user, :without_user_name) }
      expect(response.body).to include '名前を入力してください'
    end
  end    
end
