require 'active_support'

module AdminCommon
  extend ActiveSupport::Concern

  def require_admin
    redirect_to root_path , notice: "権限がありません" unless current_user.admin?
  end
end