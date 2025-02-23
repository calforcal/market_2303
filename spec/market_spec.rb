require 'rspec'
require "date"
require './lib/item'
require './lib/vendor'
require './lib/market'

RSpec.describe Market do
  before(:each) do
    allow(Date).to receive(:today).and_return(Date.new(2023,04,01))
    @market = Market.new("South Pearl Street Farmers Market") 
    @vendor1 = Vendor.new("Rocky Mountain Fresh")
    @vendor2 = vendor2 = Vendor.new("Ba-Nom-a-Nom")
    @vendor3 = Vendor.new("Palisade Peach Shack")
    @item1 = Item.new({name: "Peach", price: "$0.75"})
    @item2 = Item.new({name: "Tomato", price: '$0.50'})
    @item3 = Item.new({name: "Peach-Raspberry Nice Cream", price: "$5.30"})
    @item4 = Item.new({name: "Banana Nice Cream", price: "$4.25"})
    @vendor1.stock(@item1, 35)
    @vendor1.stock(@item2, 7)
    @vendor2.stock(@item4, 50)
    @vendor2.stock(@item3, 25)
    @vendor3.stock(@item1, 65)
  end

  describe "#initialize" do
    it "can initialize" do
      expect(@market).to be_an_instance_of(Market)
    end

    it "can initialize with attributes" do
      expect(@market.name).to eq("South Pearl Street Farmers Market")
      expect(@market.vendors).to eq([])
      expect(@market.date).to eq "01/04/2023"
    end
  end

  describe "#add_vendor" do
    it "can add a vendor" do
      @market.add_vendor(@vendor1)
      @market.add_vendor(@vendor2)
      @market.add_vendor(@vendor3)

      expect(@market.vendors).to eq([@vendor1, @vendor2, @vendor3])
    end
  end

  describe "#vendor_names" do
    it "return a list of the vendors names" do
      @market.add_vendor(@vendor1)
      @market.add_vendor(@vendor2)
      @market.add_vendor(@vendor3)

      expect(@market.vendor_names).to eq(["Rocky Mountain Fresh", "Ba-Nom-a-Nom", "Palisade Peach Shack"])
    end
  end

  describe "#vendors_that_sell" do
    it "can return a list of Vendors that sell a certain item" do
      @market.add_vendor(@vendor1)
      @market.add_vendor(@vendor2)
      @market.add_vendor(@vendor3)

      expect(@market.vendors_that_sell(@item1))
      expect(@market.vendors_that_sell(@item4))
    end
  end

  describe "#sorted_item_list" do
    it "can return an alphabetical list of in-stock items, no repeats" do
      @market.add_vendor(@vendor1)
      @market.add_vendor(@vendor2)
      @market.add_vendor(@vendor3)

      expect(@market.sorted_item_list).to eq(["Banana Nice Cream", "Peach", "Peach-Raspberry Nice Cream", "Tomato"])
    end
  end

  describe "#total_inventory" do
    it "can return a nested hash with Items as values and a hash with item quantity and vendors who sell the item" do
      @market.add_vendor(@vendor1)
      @market.add_vendor(@vendor2)
      @market.add_vendor(@vendor3)

      expect(@market.total_inventory).to eq({
        @item1 => {
          quantity: 100,
          vendors: [@vendor1, @vendor3]
        },
        @item2 => {
          quantity: 7,
          vendors: [@vendor1]
        },
        @item3 => {
          quantity: 25,
          vendors: [@vendor2]
        },
        @item4 => {
          quantity: 50,
          vendors: [@vendor2]
        }
      })
    end
  end

  describe "overstocked_items" do
    it "returns an array of Item Objects sold my more than 1 vendor AND if quantity greater than 50" do
      @market.add_vendor(@vendor1)
      @market.add_vendor(@vendor2)
      @market.add_vendor(@vendor3)

      expect(@market.overstocked_items).to eq([@item1])
    end
  end

  describe "#date" do
    it "can call the date of when a market was created" do

    end
  end

  describe "#sell" do
    it "can sell items" do
      @market.add_vendor(@vendor1)
      @market.add_vendor(@vendor2)
      @market.add_vendor(@vendor3)

      expect(@market.sell(@item1, 200)).to be false
      expect(@vendor1.check_stock(@item1)).to eq 35
      
      expect(@market.sell(@item1, 65)).to be true
      expect(@vendor1.check_stock(@item1)).to eq 0
      expect(@vendor3.check_stock(@item1)).to eq 35
    end
  end
end