module Admin
  class DashboardController < BaseController
    def show
      @user_count = User.count
      @admin_count = User.where(role: [ :content_admin, :site_admin ]).count
    end
  end
end
