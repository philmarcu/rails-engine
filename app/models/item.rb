class Item < ApplicationRecord
  # belongs_to :merchant
  
  def self.search(name)
    where("name ILIKE ?", "%#{name}%")
  end
end