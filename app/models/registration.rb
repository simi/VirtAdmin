# == Schema Information
#
# Table name: registrations
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  name       :string
#  ip_address :string
#  email      :string
#  country    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Registration < ActiveRecord::Base
  def self.create_from_user(user, ip_address=nil)
    create user_id: user.id, name: user.name, ip_address: ip_address, email: user.email,
           country: user.country
  end
end
