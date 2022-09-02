class Item < ApplicationRecord
  validates :name, presence: true
  validates :description, presence: true
  validates :unit_price, numericality: true
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items
  
  def self.search(name)
    where("name ILIKE ?", "%#{name}%")
  end

  def self.price(price)
    where("unit_price >= ?", price)
  end

  def self.mx_price(price)
    where("unit_price <= ?", price)
  end

  def self.range(min, max)
    where("unit_price >=?", min).where("unit_price <=?", max)
  end
end