class CartController < ApplicationController
  before_action :exclude_admin

  def add_item
    item = Item.find(params[:item_id])
    session[:cart] ||= {}
    if cart.limit_reached?(item.id)
      flash[:notice] = "You have all the item's inventory in your cart already!"
    else
      cart.add_item(item.id.to_s)
      session[:cart] = cart.contents
      flash[:notice] = "#{item.name} has been added to your cart!"
    end
    redirect_to items_path
  end

  def show
  end

  def empty
    session.delete(:cart)
    redirect_to '/cart'
  end

  def remove_item
    session[:cart].delete(params[:item_id])
    redirect_to '/cart'
  end

  def update_quantity
    if params[:change] == "more"
      cart.add_item(params[:item_id])
    elsif params[:change] == "less"
      cart.less_item(params[:item_id])
      return remove_item if cart.count_of(params[:item_id]) == 0
    end
    session[:cart] = cart.contents
    redirect_to '/cart'
  end

  def choose_address
    session[:cart_address_id] = params[:address_id]
    # binding.pry
    user = current_user
    @address_length = user.addresses.length
    flash[:notice] = "Your shipping address has been selected!"

    redirect_to '/cart'
  end

  def add_coupon
    user = current_user
    coupon = Coupon.find_by_name(params[:name])
    if cart.apply_coupon(coupon)
      new_total = cart.discounted_total
      flash[:notice] = "Your discount has been applied. Your new total is #{new_total}."
    else
      flash[:notice] = "That is not a valid coupon."
    end
    redirect_to '/cart'
  end
end
