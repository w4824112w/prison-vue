class LineItem < ApplicationRecord
  belongs_to :order, inverse_of: :line_items
  belongs_to :item

  validates_presence_of :order
end
