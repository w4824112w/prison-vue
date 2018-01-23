class Drawback < ApplicationRecord
  belongs_to :family

  validates :family_id, :figure, :presence => true
  validates :figure, numericality: { greater_than: 0 }
end
