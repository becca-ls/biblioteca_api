# frozen_string_literal: true

Devise.setup do |config|
  config.mailer_sender = 'please-change-me-at-config-initializers-devise@example.com'
  require 'devise/orm/active_record'

  # Para API: não usamos formatos de navegação como HTML
  config.navigational_formats = []

  # === JWT ===
  require 'devise/jwt'

  jwt_secret = ENV['DEVISE_JWT_SECRET_KEY'].presence || Rails.application.secret_key_base

  config.jwt do |jwt|
    jwt.secret = jwt_secret
    jwt.dispatch_requests = [
      ['POST', %r{^/login$}],
      ['POST', %r{^/signup$}]
    ]
    jwt.revocation_requests = [
      ['DELETE', %r{^/logout$}]
    ]
    jwt.expiration_time = 1.day.to_i
    jwt.request_formats = { user: [:json] }
  end
end
