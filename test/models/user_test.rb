# == Schema Information
#
# Table name: users
#
#  id                              :integer          not null, primary key
#  email                           :string           not null
#  crypted_password                :string
#  salt                            :string
#  created_at                      :datetime
#  updated_at                      :datetime
#  remember_me_token               :string
#  remember_me_token_expires_at    :datetime
#  activation_state                :string
#  activation_token                :string
#  activation_token_expires_at     :datetime
#  reset_password_token            :string
#  reset_password_token_expires_at :datetime
#  reset_password_email_sent_at    :datetime
#  last_login_at                   :datetime
#  last_logout_at                  :datetime
#  last_activity_at                :datetime
#  last_login_from_ip_address      :string
#  failed_logins_count             :integer          default(0)
#  lock_expires_at                 :datetime
#  unlock_token                    :string
#  name                            :string
#  country                         :string
#  locale                          :string           default("en")
#  time_zone                       :string           default("Prague")
#  approved                        :boolean          default(FALSE)
#  admin                           :boolean          default(FALSE)
#  street                          :string
#  city                            :string
#  zip                             :string
#  phone                           :string
#  contact_person                  :string
#  skype                           :string
#  jabber                          :string
#  billing_emails                  :string
#  company_number                  :string
#  vat_number                      :string
#  blocked                         :boolean          default(FALSE)
#
# Indexes
#
#  index_users_on_activation_token                     (activation_token)
#  index_users_on_email                                (email) UNIQUE
#  index_users_on_last_logout_at_and_last_activity_at  (last_logout_at,last_activity_at)
#  index_users_on_remember_me_token                    (remember_me_token)
#  index_users_on_reset_password_token                 (reset_password_token)
#  index_users_on_unlock_token                         (unlock_token)
#

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
