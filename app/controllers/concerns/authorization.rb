module Authorization
  extend ActiveSupport::Concern

  private

  def require_site_admin
    unless Current.session&.user&.site_admin?
      redirect_to root_path, alert: "You are not authorized to access this page."
    end
  end

  def require_content_admin_or_above
    unless Current.session&.user&.admin?
      redirect_to root_path, alert: "You are not authorized to access this page."
    end
  end
end
