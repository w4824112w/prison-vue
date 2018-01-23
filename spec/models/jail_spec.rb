#encoding = utf-8

require 'rails_helper'

RSpec.describe Jail, type: :model do

  before(:example) { @jail = FactoryGirl.create(:jail, title: '德山监狱') }
   
  describe '#create' do
    it 'is a valid jail' do
      expect( FactoryGirl.build(:jail) ).to be_valid
    end
    
    context 'invalid jails' do
      it 'is invalid without a title or description' do
        expect( FactoryGirl.build(:jail, title: nil) ).not_to be_valid
        expect( FactoryGirl.build(:jail, description: nil) ).not_to be_valid
      end

      it 'is invalid with zipcode already created' do
        FactoryGirl.create(:jail, zipcode: '830016')
        expect( FactoryGirl.build(:jail, zipcode: '830016') ).not_to be_valid
      end
    end

  end

  describe '#update' do
    

    it 'is a valid update' do
      expect { @jail.update_attributes({ title: '德山第一监狱', description: '德山第一监狱简介' })}.
        to change { @jail.title }.from('德山监狱').to('德山第一监狱')
    end

    it 'is a invalid update' do
      @jail.update_attributes( {title: nil, zipcode: nil} )
      expect(@jail).not_to be_valid
    end

  end


end