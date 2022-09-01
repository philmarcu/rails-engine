class Item < ApplicationRecord
  belongs_to :merchant
  validates :name, presence: true
  validates :description, presence: true
  validates :unit_price, numericality: true
  
  def self.search(name)
    where("name ILIKE ?", "%#{name}%")
  end

  def self.price(price)
    where("unit_price >= ?", price)
  end

  def self.range(min, max)
    where("unit_price >=?", min).where("unit_price <=?", max)
  end
end