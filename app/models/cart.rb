class Cart
  attr_reader :contents

  def initialize(contents)
    @contents = contents || {}
    @contents.default = 0
  end

  def add_item(item_id)
    @contents[item_id] += 1
  end

  def less_item(item_id)
    @contents[item_id] -= 1
  end

  def count
    @contents.values.sum
  end

  def items
    @contents.map do |item_id, _|
      Item.find(item_id)
    end
  end

  def grand_total
    grand_total = 0.0
    @contents.each do |item_id, quantity|
      grand_total += Item.find(item_id).price * quantity
    end
    grand_total
  end

  def apply_coupon(coupon)
    merchant_items = @contents.select do |item_id, quantity|
      item = Item.find(item_id)
      item.merchant_id == coupon.merchant_id
    end

    # => merchant_items == items from coupon's merchant
    if merchant_items.length > 0
      @coupon = coupon
    else
      # false
    end
  end

  def discounted_total
    grand_total = 0.0
    merchant_total = 0.0
    @contents.each do |item_id, quantity|
      item = Item.find(item_id)
      grand_total += item.price * quantity
      if item.merchant_id == @coupon.merchant_id
        merchant_total += item.price * quantity
      end
    end
    if merchant_total > @coupon.value
      grand_total -= @coupon.value
    else
      grand_total -= merchant_total
    end
    grand_total
  end

  def count_of(item_id)
    @contents[item_id.to_s]
  end

  def subtotal_of(item_id)
    @contents[item_id.to_s] * Item.find(item_id).price
  end

  def limit_reached?(item_id)
    count_of(item_id) == Item.find(item_id).inventory
  end
end
