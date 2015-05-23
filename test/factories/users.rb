FactoryGirl.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    country 'cz'
    locale 'cs'
    time_zone 'Prague'
    approved true

    after(:create) { |user| user.update_columns(activation_state: 'active', activation_token: nil) }
  end
end
