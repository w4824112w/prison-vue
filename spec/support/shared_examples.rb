require 'rails_helper'

RSpec.shared_examples 'validation_apply' do

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:jail_id) }
  it { should validate_presence_of(:type_id) }
  it { should validate_presence_of(:uuid) }
  it { should validate_presence_of(:phone) }
  it { should validate_presence_of(:prisoner_number) }
  it { should validate_presence_of(:relationship) }
  it { should validate_length_of(:name).is_at_least(2) }
  it { should validate_length_of(:name).is_at_most(50) }
  it { should validate_uniqueness_of(:phone).ignoring_case_sensitivity }
  it { should have_many(:uuid_images) }
  it { should belong_to(:jail) }
  it { should accept_nested_attributes_for(:uuid_images) }

end