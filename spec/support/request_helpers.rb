require 'spec_helper'

include Warden::Test::Helpers
Warden.test_mode!

module RequestHelpers
  def login(user)
    login_as user, scope: :user
  end
end

include RequestHelpers