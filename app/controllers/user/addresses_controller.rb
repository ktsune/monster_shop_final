class User::AddressesController < ApplicationController
  before_action :exclude_admin

  def index
    @user = current_user
  end

  def show
    @user = current_user
  end
end
