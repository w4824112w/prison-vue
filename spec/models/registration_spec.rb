require 'rails_helper'

RSpec.describe Registration, type: :model do

  let!(:jail)         { FactoryGirl.create :jail }
  let!(:prisoner)     { FactoryGirl.create :prisoner, jail_id: jail.id }
  let!(:registration) { FactoryGirl.create :registration, jail_id: jail.id, prisoner_number: prisoner.prisoner_number }


  it 'has a valid factory' do
    expect( FactoryGirl.create(:registration, prisoner_number: prisoner.prisoner_number, jail_id: jail.id) ).to be_valid
  end

  context 'validation' do
    it 'is invalid without a name' do
      expect(FactoryGirl.build(:registration, name: nil, prisoner_number: prisoner.prisoner_number, jail_id: jail.id)).not_to be_valid
    end

    it 'is invalid without a phone' do
      expect(FactoryGirl.build(:registration, phone: nil, prisoner_number: prisoner.prisoner_number, jail_id: jail.id)).not_to be_valid
    end

    it 'is invalid without a uuid' do
      expect(FactoryGirl.build(:registration, uuid: nil, prisoner_number: prisoner.prisoner_number, jail_id: jail.id)).not_to be_valid
    end

    it "is invalid without a prisoner's number" do
      expect(FactoryGirl.build(:registration, prisoner_number: nil)).not_to be_valid
    end

    it 'is invalid without a relationship' do
      expect(FactoryGirl.build(:registration, relationship: nil, prisoner_number: prisoner.prisoner_number, jail_id: jail.id)).not_to be_valid
    end

    it 'is invalid without a gender' do
      expect(FactoryGirl.build(:registration, gender: nil, prisoner_number: prisoner.prisoner_number, jail_id: jail.id)).not_to be_valid
    end

    context 'validate phone number' do

      it 'is invalid that the phone which registration was already passed.' do
        FactoryGirl.create(:registration, :passed, phone: '13999908705', prisoner_number: prisoner.prisoner_number, jail_id: jail.id)
        expect(FactoryGirl.build(:registration, phone: '13999908705', prisoner_number: prisoner.prisoner_number, jail_id: jail.id)).not_to be_valid
      end

      it 'is valid that the phone which registration was denied.' do
        FactoryGirl.create(:registration, :denied, phone: '17608447120', prisoner_number: prisoner.prisoner_number, jail_id: jail.id)
        expect(FactoryGirl.build(:registration, phone: '17608447120', prisoner_number: prisoner.prisoner_number, jail_id: jail.id)).to be_valid
      end

      it 'is invalid that the phone which registration status is PENDING' do
        FactoryGirl.create(:registration, phone: '17608447120', prisoner_number: prisoner.prisoner_number, jail_id: jail.id)
        expect(FactoryGirl.build(:registration, phone: '17608447120', prisoner_number: prisoner.prisoner_number, jail_id: jail.id)).not_to be_valid
      end

    end

  end

  # context '#authorization' do 
  #   context 'reject a registration' do
  #     it 'has a code with 404 when reject registration' do
  #       expect(registration.authorization('DENIED', '拒绝授权')[:code]).to eq(401)
  #       expect(registration.authorization('DENIED', '拒绝授权')[:msg]).to eq(['拒绝授权'])
  #     end
  #   end

  #   context 'agree a registration' do
  #     it 'expect 200 when agree a registration successful' do
  #       images = FactoryGirl.create_list(:uuid_image, 3, registration: registration)
  #       p registration
  #       p prisoner 
  #       expect(registration.authorization('PASSED')[:code]).to eq(200)
  #     end
  #   end
  # end

end