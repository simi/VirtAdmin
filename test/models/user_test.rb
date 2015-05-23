require 'test_helper'

describe User do
  describe 'Validations' do
    it 'check valid full name' do
      user = FactoryGirl.build(:user, name: 'John Doe')
      user.must_be :valid?

      user.name = 'Mr. John Doe, Jr.'
      user.must_be :valid?

      user.name = 'Hacker'
      user.wont_be :valid?

      user.name = 'No_name_at_all'
      user.wont_be :valid?
    end
  end

  it 'works properly with the activation token' do
    token = Faker::Lorem.characters 25
    FactoryGirl.create(:user).update_columns activation_token: token, activation_state: 'pending'

    User.load_from_activation_token(token).wont_be_nil
    lambda do
      travel_to(Time.zone.now + 45.minute) do
        User.load_from_activation_token(token).must_be_nil
      end
    end.must_change 'User.count', -1
  end
end
