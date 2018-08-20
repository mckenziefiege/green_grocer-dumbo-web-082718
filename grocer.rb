require "pry"

def consolidate_cart(cart)
  cart.each_with_object({}) do |food_item, result|
    food_item.each do |food_name, info_hash|
      if result[food_name]
        info_hash[:count] += 1
      else
        info_hash[:count] = 1
        result[food_name] = info_hash
      end
    end
  end
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    food_name = coupon[:item]
    if cart[food_name] && cart[food_name][:count] >= coupon[:num]
      if cart["#{food_name} W/COUPON"]
        cart["#{food_name} W/COUPON"][:count] += 1
      else
        cart["#{food_name} W/COUPON"] = {:count => 1, :price => coupon[:cost]}
        cart["#{food_name} W/COUPON"][:clearance] = cart[food_name][:clearance]
      end
      cart[food_name][:count] -= coupon[:num]
    end
  end
  cart
end

def apply_clearance(cart)
  cart.each do |food_item, info_hash|
    if info_hash[:clearance]
      updated_price = info_hash[:price] * 0.80
      info_hash[:price] = updated_price.round(2)
    end
  end
  cart
end

def checkout(cart, coupons)
  consolidated_cart = consolidate_cart(cart)
  cart_with_coupons = apply_coupons(consolidated_cart, coupons)
  new_cart = apply_clearance(cart_with_coupons)
  total_price = 0
  new_cart.each do |food_item, info_hash|
    total_price += info_hash[:price] * info_hash[:count]
  end
  total_price = total_price * 0.90 if total_price > 100
  total_price
end
