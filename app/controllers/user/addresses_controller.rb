class User::AddressesController < ApplicationController
  before_action :exclude_admin

  def index
    @user = current_user
  end
end
