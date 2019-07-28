class User::AddressesController < ApplicationController
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
    if @user.addresses.update(address_params)
      flash[:notice] = 'Your address has been updated!'
      redirect_to "/profile/#{@address.id}"
    else
      generate_flash(@address)
      render :edit
    end
  end

  def destroy
    @user = current_user
    @address = Address.find(params[:id])
    @address.destroy

    redirect_to "/profile/addresses"
  end

  private

  def address_params
    params.permit(:nickname, :address, :state, :city, :zip)
  end
end
