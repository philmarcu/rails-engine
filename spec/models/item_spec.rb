require 'rails_helper'

RSpec.describe Item, type: :model do
  describe ".class methods" do
    it 'can search for merchants where name is similar' do
      m = Merchant.create!(name: "Bob")
      item_1 = m.items.create!(name: "bob", description: "an item!", unit_price: 2.00)
      item_2 = m.items.create!(name: "Dale", description: "an item!", unit_price: 2.00)
      item_3 = m.items.create!(name: "Jill", description: "an item!", unit_price: 2.00)
      item_4 = m.items.create!(name: "Jack", description: "an item!", unit_price: 2.00)
      item_5 = m.items.create!(name: "Johnny", description: "an item!", unit_price: 2.00)
      
      expect(Item.search("j")).to eq([item_3, item_4, item_5])
    end
  end
end