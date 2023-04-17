class Vendor
  attr_reader :name, :inventory

  def initialize(name)
    @name = name
    @inventory = {}
  end

  def check_stock(item)
    return 0 if @inventory[item] == nil

    @inventory[item]
  end

  def stock(item, amount)
    if check_stock(item) == 0 then @inventory[item] = amount else @inventory[item] += amount end 
  end

  def potential_revenue
    revenues = 0.0
    @inventory.each do |item, amount|
      revenues += price_to_float(item.price) * amount.to_f
    end
    revenues
  end

  def price_to_float(price)
    price.delete("$").to_f
  end
end