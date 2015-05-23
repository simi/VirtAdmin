if Rails.env.development?
  admin = User.create name: 'Joe Admin', email: 'admin@admin.com', password: 'password',
                      password_confirmation: 'password', country: 'CZ', locale: 'cs', admin: true, approved: true

  admin.update_columns activation_state: 'active', activation_token: nil
end
