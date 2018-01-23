#encoding = utf-8
require 'rails_helper'

RSpec.describe Meeting, type: :model do

  let!(:jail) { FactoryGirl.create(:jail) }
  let!(:configuration) { FactoryGirl.create(:configuration, jail: jail) }
  let!(:prisoner) { FactoryGirl.create(:prisoner, jail: jail) }
  let!(:family) { FactoryGirl.create(:family, prisoner: prisoner, balance: 100) }
  let!(:ternimals) { FactoryGirl.create_list(:terminal, 3, jail: family.prisoner.jail) }
  
  it 'has a valid factory' do
    expect(FactoryGirl.build(:meeting, application_date: "#{1.day.from_now}", family: family)).to be_valid
    expect(family.balance).to be >= 50
  end

  context '.application a meeting' do

    it 'is invalid that the application date is earlier than or equal to today' do
      result = Meeting.application(application_date: "#{1.day.ago}", family_id: family.id)
      expect(result[:code]).to eq(400)
      expect(result[:errors]).to eq('Validation failed: Application date 申请日期不能早于或等于当天')
    end

    it 'is invalid that submit an application again when the earlyer application has not approved yet' do
      meeting = FactoryGirl.create(:meeting, application_date: "#{1.day.from_now}", family: family)
      result =  Meeting.application(application_date: "#{1.day.from_now}", family_id: family.id)

      expect(meeting.status).to eq('PENDING')
      expect(result[:code]).to eq(400)
      expect(result[:errors]).to eq('Validation failed: Status 您的申请正在审核中，请勿重复提交')
    end

    it 'is invalid that submit an application when there is another application that was passed 
        and submitted by same family' do
      FactoryGirl.create(:meeting, application_date: "#{1.day.from_now}", family: family, status: 'PASSED')
      result = Meeting.application(application_date: "#{1.day.from_now}", family_id: family.id)
      expect(result[:code]).to eq(400)
      expect(result[:errors]).to eq('Validation failed: Family 该日申请已经批准，请勿重复申请')
    end

    context 'meeting queues' do
      it 'returns a hash within code that equals 400 when the meeting queues is full' do
        allow_any_instance_of(Meeting).to receive(:full?).and_return(true)
        result = Meeting.application( application_date: "#{1.day.from_now}", family_id: family.id)
        expect(result[:code]).to eq(400)
        expect(result[:errors]).to eq('Validation failed: Number limit 当日申请已满')
      end

      it 'returns a hash within code that equals 200 when meeting queues is not full' do
        allow_any_instance_of(Meeting).to receive(:full?).and_return(false)
        result = Meeting.application(application_date: "#{1.day.from_now}", family_id: family.id)
        expect(result[:code]).to eq(200)
      end
    end

    context 'balance insufficient' do
      it 'returns a hash within code that equals 400 when the balance of family is insufficient' do
        new_family = FactoryGirl.create(:family, balance: 45, prisoner: prisoner)
        result = Meeting.application(application_date: "#{1.day.from_now}", family_id: new_family.id)
        expect(result[:code]).to eq(400)
        expect(result[:errors]).to eq('Validation failed: Balance 余额不足')
      end

      it 'returns a hash within code that equals 200 when the balance of family is enough' do
        new_family = FactoryGirl.create(:family, balance: 50, prisoner: prisoner)
        result = Meeting.application(application_date: "#{1.day.from_now}", family_id: new_family.id)
        expect(result[:code]).to eq(200)
      end
    end

  end

  context '.deny an application' do

    it 'returns a hash within code that equals 400 when refuse a non-existent meeting' do
      result = Meeting.deny(999, 'non-existent meeting')
      expect(result[:code]).to eq(400)
      expect(result[:error]).to eq('Can not refuse a non-existent meeting 999')
    end

    it 'returns a hash within code that equals 400 when the meeting has been reviewed' do
      passed_meeting = FactoryGirl.create(:meeting, application_date: "#{1.day.from_now}", family: family, status: 'PASSED')
      denied_meeting = FactoryGirl.create(:meeting, application_date: "#{2.day.from_now}", family: family, status: 'DENIED')

      result_of_passed_meeting = Meeting.deny(passed_meeting.id, 'already reviewed')
      result_of_denied_meeting = Meeting.deny(denied_meeting.id, 'already reviewed')

      expect(result_of_passed_meeting[:code]).to eq(400)
      expect(result_of_passed_meeting[:error]).to eq("The meeting: #{passed_meeting.id} has been reviewed and can not be reviewed again")

      expect(result_of_denied_meeting[:code]).to eq(400)
      expect(result_of_denied_meeting[:error]).to eq("The meeting: #{denied_meeting.id} has been reviewed and can not be reviewed again")
    end

    it 'returns a hash within code that equals 500 when denies a meeting occurs an error' do
      meeting = FactoryGirl.create(:meeting, application_date: "#{1.day.from_now}", family: family)
      allow_any_instance_of(Meeting).to receive(:update_attributes).and_return(false)
     
      result = Meeting.deny(meeting.id, 'occurs error')
      
      expect(result[:code]).to eq(500)
      expect(result[:error]).to eq("Reject meeting: #{meeting.id} operation failed")
    end

    it 'returns a hash with code that equals 200 when denies a meeting successfully' do
      FactoryGirl.create(:api_key, family: family)
      meeting = FactoryGirl.create(:meeting, application_date: "#{1.day.from_now}", family: family)

      result = Meeting.deny(meeting.id, 'denied success')
      expect(result[:code]).to eq(200)
      expect(result[:msg]).to eq("Refuse the meeting #{meeting.id} success")
    end
  end
end