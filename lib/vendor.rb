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
end