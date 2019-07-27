class User::AddressesController < ApplicationController
  before_action :exclude_admin

  def index
  end
end
