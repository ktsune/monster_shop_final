class Merchant::CouponsController < Merchant::BaseController
  def index
    @coupons = Coupon.all
    @merchant = Merchant.find(params[:id])
  end

  def new
  end

  def create
    @merchant = Merchant.find(params[:id])
    @coupon = @merchant.coupons.new(coupon_params)
    if @coupon.save
      flash[:notice] = 'You have added a coupon!'
      redirect_to "/merchants/#{@merchant.id}/coupons"
    else
      generate_flash(@coupon)
      render :new
    end
  end

private

  def coupon_params
    params.permit(:name, :value, :enabled)
  end
end
