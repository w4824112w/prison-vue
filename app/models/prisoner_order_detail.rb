class PrisonerOrderDetail < ApplicationRecord
    belongs_to :prisoner_order
    belongs_to :prisoner
end
