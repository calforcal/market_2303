require "date"

class Market
  attr_reader :name, :vendors

  def initialize(name)
    @name = name
    @vendors = []
    @date = Date.today
  end

  def date
    @date.strftime("%d/%m/%Y")
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
    @vendors.flat_map do |vendor|
      vendor.inventory.keys.map do |item|
        item.name
      end
    end.uniq.sort
    # stocks = @vendors.map { |vendor| vendor.inventory }
    # stocks.flat_map{ |stock| stock.keys.map { |key| key.name } }.uniq.sort
  end

  def total_inventory
    total = {}
    @vendors.each do |vendor|
      vendor.inventory.each do |item, quantity|
        if total[item]
          total[item][:quantity] += quantity
        else 
          total[item] = {
            quantity: quantity,
            vendors: vendors_that_sell(item)
          }
        end
      end
    end
    total
    # total_stock = inventory_items.map { |item| [item, Hash.new()]}.to_h

    # total_stock.each do |item, hash|
    #   hash[:quantity] = total_quantities(item)
    #   hash[:vendors] = vendors_that_sell(item)
    # end
  end

  def inventory_items
    stocks = @vendors.map { |vendor| vendor.inventory }
    stocks.flat_map{ |stock| stock.keys.map { |key| key} }.uniq
  end

  def total_quantities(item)
    vendors = vendors_that_sell(item)
    count = vendors.map { |vendor| vendor.check_stock(item) }.sum
  end

  def overstocked_items
    total_inventory.select do |item, info|
      info[:quantity] > 50 && info[:vendors].length > 1
    end.keys
    # inventory = total_inventory
    # overstocked_items = []

    # inventory.each do |key, value|
    #   if value[:quantity] > 50 && value[:vendors].count > 1
    #     overstocked_items << key
    #   end
    # end
    # overstocked_items.flatten
  end

  def sell(item, quantity)
    return false if total_inventory[item][:quantity] < quantity

    @vendors.each do |vendor|
      if vendor.check_stock(item) > quantity
        vendor.inventory[item] -= quantity
        break
      else
        quantity -= vendor.inventory[item]
        vendor.inventory[item] = 0
      end
    end
    return true
  end
end