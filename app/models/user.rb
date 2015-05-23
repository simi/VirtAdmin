class User < ActiveRecord::Base
  has_paper_trail only: [:name, :email, :locale, :country]

  authenticates_with_sorcery!

  validates :name, format: /\A(?=.* )[^0-9`!@#\\\$%\^&*\;+_=]{4,}\z/
  validates :email, uniqueness: true
  validates :password, length: { minimum: 6 }
  validates :password, confirmation: true, presence: true
  validates :email, :name, :country, :locale, :time_zone, presence: true

  def change_locale!(new_locale)
    update_attribute :locale, new_locale
  end

  def activated?
    activation_state == 'active'
  end

  def approve!
    update_attribute :approved, true
  end

  def self.load_from_activation_token(token)
    user = super token
    User.find_by(activation_token: token).try(:destroy) unless user
    user
  end
end
