class Merchant < ApplicationRecord
  validates :name, presence: true

  has_many :items
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items

  def self.search(name)
    where("name ILIKE ?", "%#{name}%")
  end
end
