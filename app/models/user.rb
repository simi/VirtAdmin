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

class User < ActiveRecord::Base
  has_paper_trail only: [:name, :email, :locale, :country]

  authenticates_with_sorcery!

  validates :name, format: /\A(?=.* )[^0-9`!@#\\\$%\^&*\;+_=]{4,}\z/
  validates :email, uniqueness: true
  validates :password, length: { minimum: 6 }
  validates :password, confirmation: true, presence: true
  validates :email, :name, :country, :locale, :time_zone, presence: true

  scope :by_country, -> (country) { where country: country }
  scope :by_locale, -> (locale) { where locale: locale }
  scope :admins, -> { where admin: true }

  def change_locale!(new_locale)
    update_attribute :locale, new_locale
  end

  def activated?
    activation_state == 'active'
  end

  def approve!
    update_attribute :approved, true
  end

  def block!
    update_attribute :blocked, true
  end

  def unblock!
    update_attribute :blocked, false
  end

  def locale
    super.to_sym
  end

  def self.load_from_activation_token(token)
    user = super token
    User.find_by(activation_token: token).try(:destroy) unless user
    user
  end
end
