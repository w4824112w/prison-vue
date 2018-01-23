require 'rails_helper'

RSpec.describe Order, type: :model do

  let(:family) { FactoryGirl.create(:family) }
  let!(:config) { FactoryGirl.create(:configuration, jail_id: family.prisoner.jail.id) }

  let(:items_with_type_normal) { FactoryGirl.create_list(:item, 5, jail_id: family.prisoner.jail.id, price: 10) }
  let(:line_items_attributes) { items_with_type_normal.map{ |item| {item_id: item.id, quantity: 1} } }
  


  it 'has a valid factory' do  
    expect(FactoryGirl.build(:order, 
                             jail_id: family.prisoner.jail.id,
                             family_id: family.id,
                             line_items_attributes: line_items_attributes)).to be_valid
  end

  context 'validations' do
    # it 'is invalid that without amount' do
    #   invalid_order = FactoryGirl.build(:order, 
    #                                     jail_id: family.prisoner.jail.id,
    #                                     family_id: family.id,
    #                                     amount: nil,
    #                                     line_items_attributes: line_items_attributes)

    #   expect(invalid_order).not_to be_valid
    #   expect(invalid_order.errors.messages).to eq({amount: ["can't be blank", "is not a number"]})
    # end

    it 'is invalid that without id of jail' do
      invalid_order = FactoryGirl.build(:order, 
                                        jail_id: nil,
                                        family_id: family.id,
                                        line_items_attributes: line_items_attributes)

      expect(invalid_order).not_to be_valid
      expect(invalid_order.errors.messages).to eq({jail_id: ["can't be blank"]})
    end

    # it 'invalid that without an id of family' do
    #   invalid_order = FactoryGirl.build(:order, 
    #                                     jail_id: family.prisoner.jail.id,
    #                                     family_id: nil,
    #                                     line_items_attributes: line_items_attributes)

    #   expect(invalid_order).not_to be_valid
    #   expect(invalid_order.errors.messages).to eq({family_id: ["can't be blank"]})
    # end

    it 'is invalid that without trade_no' do
      invalid_order = FactoryGirl.build(:order, 
                                        jail_id: family.prisoner.jail.id,
                                        family_id: family.id,
                                        trade_no: nil,
                                        line_items_attributes: line_items_attributes)

      expect(invalid_order).not_to be_valid
      expect(invalid_order.errors.messages).to eq({trade_no: ["can't be blank"]})
    end

    it 'is invalid that the amount is not greater_than 0' do
      invalid_order = FactoryGirl.build(:order, 
                                        jail_id: family.prisoner.jail.id,
                                        family_id: family.id,
                                        amount: 0,
                                        line_items_attributes: line_items_attributes)

      expect(invalid_order).not_to be_valid
      expect(invalid_order.errors.messages).to eq({amount: ["must be greater than 0"]})
    end
  end

  context 'validates restrictions' do
    let(:item_with_type_a) { FactoryGirl.create(:item, jail_id: family.prisoner.jail.id, barcode: 'A') }
    let(:item_with_type_b) { FactoryGirl.create(:item, jail_id: family.prisoner.jail.id, barcode: 'B', price: 850) }

    it 'return true when trade type was `A` that means recharge has no restriction' do
      order = FactoryGirl.build(:order,
                                 family_id: family.id, 
                                 jail_id: family.prisoner.jail.id, 
                                 line_items_attributes: [{item_id: item_with_type_a.id, quantity: 1}])
      
      expect(order).to be_valid
    end

    it 'is invalid when maximum amount exceeded and raise an error with limit restriction message' do
      order = FactoryGirl.build(:order,
                                 family_id: family.id,
                                 jail_id: family.prisoner.jail.id,
                                 amount: item_with_type_b.price,
                                 line_items_attributes: [{item_id: item_with_type_b.id, quantity:1}])

      expect(order).not_to be_valid
      expect(order.errors.messages).to eq({restriction: ["limit restriction"]})
    end

    it 'is invalid when occurs consumption restriction' do
      item = FactoryGirl.create(:item, jail_id: family.prisoner.jail.id, price: 100)

      # Create an order list that each status was `TRADE_SUCCESS`
      # there is an consumption restrict which is the amount of
      # consumption in the same month could not greater than the
      # settings of prison. The restriction of this test case is 400. 
      4.times do
        FactoryGirl.create(:order, 
                           family_id: family.id, 
                           jail_id: family.prisoner.jail.id,
                           status: 'TRADE_SUCCESS',
                           line_items_attributes: [{item_id: item.id, quantity: 1}])
      end
      
      order = FactoryGirl.build(:order, 
                                family_id: family.id, 
                                jail_id: family.prisoner.jail.id, 
                                line_items_attributes: [{item_id: item.id, quantity: 1}])

      expect(order).not_to be_valid
      expect(order.errors.messages).to eq({restriction: ["limit restriction"]})
    end
  end

end