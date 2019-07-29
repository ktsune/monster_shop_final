class User::AddressesController < ApplicationController
  before_action :require_user
  before_action :exclude_admin

  def index
    @user = current_user
  end

  def show
    @user = current_user
    @address = Address.find(params[:id])
  end

  def new
    @address = Address.new
  end

  def create
    @user = current_user
    @address = @user.addresses.new(address_params)
    if @address.save
      flash[:notice] = 'Your new address has been saved!'
      redirect_to "/profile/addresses"
    else
      generate_flash(@address)
      render :new
    end
  end

  def edit
    @address = Address.find(params[:id])
  end

  def update
    @user = current_user
    @address = Address.find(params[:id])
    @address.update(address_params)
    flash[:notice] = 'Your address has been updated!'
    redirect_to "/profile/#{@address.id}"
  end

  def destroy
    @address = Address.find(params[:id])
    if @address.shipped_order?
      flash[:notice] = 'This address has been used in a shipped order and cannot be deleted!'
    else
      @user = current_user
      @address.destroy
    end
    redirect_to "/profile/addresses"
  end

  private

  def address_params
    params.permit(:nickname, :address, :state, :city, :zip)
  end
end
