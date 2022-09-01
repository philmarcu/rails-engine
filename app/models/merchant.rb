class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices

  def self.search(name)
    where("name ILIKE ?", "%#{name}%")
  end

  def valid
    self.id.present?
  end
end
