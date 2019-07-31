class User::OrdersController < ApplicationController

  def index
    @orders = current_user.orders
  end

  def show
    @order = current_user.orders.find(params[:id])
    @addresses = current_user.addresses
  end

  def create
    if session[:cart_address_id]
      order = current_user.orders.new(address_id: session[:cart_address_id])
    else
      id = current_user.addresses.map do |address_info|
        address_info.id
      end
      order = current_user.orders.new(address_id: id.join(" ").to_i)
    end
    
    order.save!
      cart.items.each do |item|
        order.order_items.create({
          item: item,
          quantity: cart.count_of(item.id),
          price: item.price
          })
      end
    session.delete(:cart)
    flash[:notice] = "Order created successfully!"
    redirect_to '/profile/orders'
  end

  def update
    @order = Order.find(params[:id])
    @order.address = Address.find(params[:address])
    @order.save
    @addresses = current_user.addresses

    render :show
  end

  def cancel
    order = current_user.orders.find(params[:id])
    order.cancel
    redirect_to "/profile/orders/#{order.id}"
  end
end
