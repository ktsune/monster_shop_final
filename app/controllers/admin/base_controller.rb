class Admin::BaseController < ApplicationController
  before_action :require_admin

  private

  def require_admin
    unless current_admin?
      render file: '/public/404', status: 404, layout: false
    end
  end
end
