#encoding = utf-8

require 'faker'
require 'date'

FactoryGirl.define do

  factory :jail do
    title                { Faker::Lorem.word }
    description          { Faker::Lorem.word }
    street               { Faker::Address.street_address }
    city                 { Faker::Address.city }
    district             { Faker::Address.street_name }
    state                { Faker::Address.state }
    zipcode              { Faker::Address.zip_code }
    image_file_name      { "#{Faker::Number.number(1)}-#{DateTime.now.to_i}.png?#{DateTime.now.to_i}" }
    image_content_type   'image/png'
    image_file_size      { Faker::Number.number(4) }
  end

  factory :family do
    name           { Faker::Name.name }
    uuid           { Faker::Code.ean }
    phone          { Faker::PhoneNumber.cell_phone }
    balance        { Faker::Number.decimal(3, 2)}
    relationship   '兄弟'
    
    prisoner
  end

  factory :category do
    title { Faker::Lorem.word }
  end
  
  factory :item do
    jail
    category

    title       { Faker::Lorem.word }
    description { Faker::Lorem.word }
    price       { Faker::Number.decimal(3, 2) }
    barcode     { Faker::Code.asin }
  end

  factory :line_item do
    item
    order

    quantity { Faker::Number.number(2) }
  end

  factory :order do
    jail
    family

    trade_no        { Faker::Code.ean }
    payment_type    'weixin'
    status          'WAIT_FOR_PAYMENT'
    amount          { Faker::Number.decimal(2, 2)}
    gmt_payment     { Time.now }
    ip              { Faker::Internet.ip_v4_address }
  end

  factory :configuration do
    jail
    settings      { {"cost": 50,
                     "meeting_queue": [
                       "9:00 - 9:30",
                       "9:30 - 10:00",
                       "10:00 - 10:30",
                       "10:30 - 11:00",
                       "11:00 - 11:30",
                       "11:30 - 12:00",
                       "14:00 - 14:30",
                       "14:30 - 15:00",
                       "15:00 - 15:30",
                       "15:30 - 16:00",
                       "16:00 - 16:30",
                       "16:30 - 17:00"
                      ],
                      "modules": {"meeting": 1, "shopping": 1},
                      "restrictions": {"remittance": 800, "consumption":400}
                   } }
  end

  factory :prisoner do
    jail
    name            { Faker::Name.name }
    prisoner_number { Faker::Number.number(10) }
  end

  factory :api_key do
    access_token    { Faker::Code.ean }
    family
  end

  factory :registration do
    name              { Faker::Name.name }
    phone             { Faker::PhoneNumber.cell_phone }
    uuid              { Faker::Code.ean }
    prisoner_number   { Faker::Number.number(10) }
    relationship      '兄弟'
    gender            '男'
    
    trait :denied do
      status 'DENIED'
    end

    trait :passed do
      status 'PASSED'
    end

    jail
  end

  factory :uuid_image do
    image_file_name      { "#{Faker::Number.number(1)}-#{DateTime.now.to_i}.png?#{DateTime.now.to_i}" }
    image_content_type   'image/png'
    image_file_size      { Faker::Number.number(4) }
    association :registration, factory: :registration
  end

  factory :terminal do
    jail
    terminal_number      { "#{Faker::Number.number(5)}" }
  end

  factory :meeting do
    application_date { 1.day.from_now.to_s }

    trait :denied do
      status 'DENIED'
    end

    trait :passed do
      status 'PASSED'
    end

    family
    terminal
  end

end