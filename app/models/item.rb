class Item < ApplicationRecord
  # belongs_to :merchant
  validates :name, presence: true
  validates :description, presence: true
  validates :unit_price, numericality: true
  
  def self.search(name)
    where("name ILIKE ?", "%#{name}%")
  end
end