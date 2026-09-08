require 'simplecov'
SimpleCov.start 'rails' do
  skip "/channels/"
  skip "/jobs/"
  skip "/mailers/"
end

require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

Capybara.default_host = 'http://127.0.0.1'

RSpec.configure do |config|
  config.fixture_paths = [
    Rails.root.join('spec/fixtures')
  ]

  config.use_transactional_fixtures = true
  config.filter_rails_from_backtrace!

  config.include FactoryBot::Syntax::Methods

  # Devise ヘルパーの設定
  config.include Devise::Test::IntegrationHelpers, type: :system
  config.include Devise::Test::IntegrationHelpers, type: :request

  # リクエストスペック設定（ホスト設定 + CSRF保護の無効化）
  config.before(:each, type: :request) do
    host! "localhost"
    ActionController::Base.allow_forgery_protection = false
  end

  # システムスペック設定（selenium を使わず高速な rack_test で実行）
  config.before(:each, type: :system) do
    driven_by :rack_test
  end
end
