class Merchant::CouponsController < Merchant::BaseController
  def index
    @coupons = Coupon.all
    @merchant = Merchant.find(params[:id])
  end

end
