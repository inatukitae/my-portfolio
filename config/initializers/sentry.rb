# config/initializers/sentry.rb
Sentry.init do |config|
  config.dsn = ENV["SENTRY_DSN"]
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]

  # 本番環境のみエラーを送信
  config.enabled_environments = %w[production]

  config.send_default_pii = true
end