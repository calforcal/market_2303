class Market
  attr_reader :name, :vendors

  def initialize(name)
    @name = name
    @vendors = []
  end

  def add_vendor(vendor)
    @vendors << vendor
  end

  def vendor_names
    @vendors.map(&:name)
  end

  def vendors_that_sell(item)
    @vendors.select{ |vendor| vendor.inventory.has_key?(item) && vendor.check_stock(item) != 0 }
  end

  def sorted_item_list
    stocks = @vendors.map { |vendor| vendor.inventory }
    stocks.flat_map{ |stock| stock.keys.map { |key| key.name } }.uniq.sort
  end

  def total_inventory
    total_stock = inventory_items.map { |item| [item, Hash.new()]}.to_h

    total_stock.each do |item, hash|
      hash[:quantity] = total_quantities(item)
      hash[:vendors] = vendors_that_sell(item)
    end
  end

  def inventory_items
    stocks = @vendors.map { |vendor| vendor.inventory }
    stocks.flat_map{ |stock| stock.keys.map { |key| key} }.uniq
  end

  def total_quantities(item)
    vendors = vendors_that_sell(item)
    count = vendors.map { |vendor| vendor.check_stock(item) }.sum
  end
end