require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe ".class methods" do
    it 'can search for merchants where name is similar' do
      merchant_1 = Merchant.create!(name: "bob")
      merchant_2 = Merchant.create!(name: "Dale")
      merchant_3 = Merchant.create!(name: "Jill")
      merchant_4 = Merchant.create!(name: "Jack")
      merchant_5 = Merchant.create!(name: "Johnny")
      
      expect(Merchant.search("j")).to eq([merchant_3, merchant_4, merchant_5])
    end
  end

  describe '#instance methods' do
    it 'can tell if id is valid or not' do
      merchant_1 = Merchant.create!(name: "bob")
      merchant_2 = Merchant.create!(name: "Dale")
      
      expect(merchant_1.valid).to eq(true)
    end
  end
end
