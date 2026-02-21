module Admin
  class UsersController < BaseController
    before_action :require_site_admin

    def index
      @users = User.order(created_at: :desc)
    end
  end
end
