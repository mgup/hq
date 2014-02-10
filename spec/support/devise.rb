RSpec.configure do |config|
  config.include Devise::TestHelpers, type: :controller
  config.after(:each) { Warden.test_reset! }
end

include Warden::Test::Helpers
Warden.test_mode!

def as_user(user = nil, &block)
  current_user = user || FactoryGirl.create(:user)
  login_as(current_user, scope: :user)
  block.call if block.present?
  return self
end

def as_guest(&block)
  logout(:user)
  block.call if block.present?
  return self
end