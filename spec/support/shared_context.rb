require 'rails_helper'

RSpec.shared_context 'create order' do

  before do
     @current_order = create :order, :valid_order
  end
end